import CoreLocation
import Foundation
import Combine

class AutocompleteViewModel: ObservableObject {
    @Published var suggestions: [String] = []
    @Published var coordinates: (latitude: Double, longitude: Double)? = nil
    @Published var selectedCityWeatherViewModel: WeatherViewModel?
    private var cancellables = Set<AnyCancellable>()
    private let googleApiKey = "AIzaSyB32ZyEKGCtbQ3ljMmb_ieZdMZhBXHZ8IA"
    
    
        var weatherViewModel: WeatherViewModel?
    
    let stateAbbreviations: [String: String] = [
        "AL": "Alabama", "AK": "Alaska", "AZ": "Arizona", "AR": "Arkansas", "CA": "California",
        "CO": "Colorado", "CT": "Connecticut", "DE": "Delaware", "FL": "Florida", "GA": "Georgia",
        "HI": "Hawaii", "ID": "Idaho", "IL": "Illinois", "IN": "Indiana", "IA": "Iowa",
        "KS": "Kansas", "KY": "Kentucky", "LA": "Louisiana", "ME": "Maine", "MD": "Maryland",
        "MA": "Massachusetts", "MI": "Michigan", "MN": "Minnesota", "MS": "Mississippi", "MO": "Missouri",
        "MT": "Montana", "NE": "Nebraska", "NV": "Nevada", "NH": "New Hampshire", "NJ": "New Jersey",
        "NM": "New Mexico", "NY": "New York", "NC": "North Carolina", "ND": "North Dakota", "OH": "Ohio",
        "OK": "Oklahoma", "OR": "Oregon", "PA": "Pennsylvania", "RI": "Rhode Island", "SC": "South Carolina",
        "SD": "South Dakota", "TN": "Tennessee", "TX": "Texas", "UT": "Utah", "VT": "Vermont",
        "VA": "Virginia", "WA": "Washington", "WV": "West Virginia", "WI": "Wisconsin", "WY": "Wyoming"
    ]

    func fetchSuggestions(for input: String) {
        guard !input.isEmpty, let url = URL(string: "https://weatherappbackend-441501.uw.r.appspot.com/autocomplete?input=\(input)") else {
            suggestions = []
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: AutocompleteResponse.self, decoder: JSONDecoder())
            .replaceError(with: AutocompleteResponse(predictions: []))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.suggestions = response.predictions.map { suggestion in
                    self?.extractCityAndState(from: suggestion.description) ?? ""
                }
            }
            .store(in: &cancellables)
    }

    func extractCityAndState(from description: String) -> String {
        let components = description.split(separator: ",")
        
        
        guard components.count >= 2 else {
            return ""
        }
        
        let city = components[0].trimmingCharacters(in: .whitespaces)
        
       
        let stateAbbr = components[1].trimmingCharacters(in: .whitespaces).split(separator: " ").first ?? ""
        
        
        let fullState = stateAbbreviations[String(stateAbbr)] ?? String(stateAbbr)
        
        return "\(city), \(fullState)"
    }

    func fetchCoordinates(for city: String, completion: @escaping (Location?) -> Void) 
    {

        let geocodeUrl = "https://maps.googleapis.com/maps/api/geocode/json"
               let fullUrl = "\(geocodeUrl)?address=\(city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city)&key=\(googleApiKey)"
               
               guard let url = URL(string: fullUrl) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
                    .map(\.data)
                    .decode(type: GeocodeResponse.self, decoder: JSONDecoder())
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            print("Error fetching coordinates: \(error.localizedDescription)")
                        }
                    }, receiveValue: { [weak self] response in 
                        if let location = response.results.first?.geometry.location {
                            self?.coordinates = (latitude: location.lat, longitude: location.lng)
                            print("Coordinates for \(city): \(location.lat), \(location.lng)")
                            
                                            let weatherViewModel = WeatherViewModel(city: city)
                            weatherViewModel.coordinates = self?.coordinates
                                            
                                            
                                            self?.selectedCityWeatherViewModel = weatherViewModel
                        } else {
                            print("No coordinates found for \(city)")
                        }
                    })
                    .store(in: &cancellables)
       }
    
}

