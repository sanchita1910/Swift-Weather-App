
import CoreLocation
import Foundation


class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var weather: WeatherData?
    @Published var city: String
    private let locationManager = CLLocationManager()
    var coordinates: (latitude: Double, longitude: Double)?
    private var weatherFetchCompletion: ((Bool) -> Void)?

    init(city: String = "Fetching location...") {
        self.city = city
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func requestCurrentLocationWeather(completion: ((Bool) -> Void)? = nil) {
        weatherFetchCompletion = completion
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            completion?(false)
        }
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        guard let url = URL(string: "https://weatherappbackend-441501.uw.r.appspot.com/weather?lat=\(latitude)&lon=\(longitude)") else {
            print("Invalid URL")
            weatherFetchCompletion?(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let data = data {
                do {
                    let weather = try JSONDecoder().decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        self?.weather = weather
                        self?.weatherFetchCompletion?(true)
                        self?.weatherFetchCompletion = nil
                    }
                } catch {
                    print("Error decoding weather data: \(error)")
                    self?.weatherFetchCompletion?(false)
                }
            } else if let error = error {
                print("Error fetching weather: \(error)")
                self?.weatherFetchCompletion?(false)
            }
        }.resume()
    }
    

    func reverseGeocode(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                self?.city = "Unable to fetch city"
            } else if let placemark = placemarks?.first {
                self?.city = placemark.locality ?? "Unknown City"
            }
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            weatherFetchCompletion?(false)
            return
        }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        fetchWeather(latitude: latitude, longitude: longitude)
        reverseGeocode(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to fetch location: \(error.localizedDescription)")
        weatherFetchCompletion?(false)
    }
}
