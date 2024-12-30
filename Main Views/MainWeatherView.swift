
import SwiftUI
import UIKit
import CoreLocation
import Foundation

struct MainWeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var autocompleteViewModel = AutocompleteViewModel()
    @State private var searchText = ""
    @State private var favorites: [Favorite] = []
    @State private var favoriteWeathers: [WeatherData?] = []
    @State private var currentPage = 0
    @State private var isCurrentLocationLoaded = false
    private let googleApiKey = "AIzaSyB32ZyEKGCtbQ3ljMmb_ieZdMZhBXHZ8IA"
    @State private var isFavorited: Bool = true
    @State private var favoriteId: String?
    @State private var showToast: Bool = false
    
    


    var body: some View {
        NavigationView {
            ZStack {
                // Background img
                VStack(spacing: 0) {
                    Color.white
                        .frame(height: 50)
                        .ignoresSafeArea()
                    Image("App_background")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .ignoresSafeArea(edges: .bottom)
                }

                VStack(spacing: 20) {
                    // Search Bar code
                    
                    VStack(spacing: 0) {
                    SearchBar(text: $searchText, viewModel: autocompleteViewModel)
                        .padding(.horizontal)
                        .padding(.bottom, 6)
                }
                .zIndex(1)

                    // Weather Pages code

                    TabView(selection: $currentPage) {
                        // Current Location Weather
                        if isCurrentLocationLoaded, let weather = viewModel.weather {
                            weatherDetailView(
                                weather: weather,
                                city: viewModel.city,
                                isCurrentLocation: true
                            )
                            .tag(0)
                        }

                        // Favorite Cities Weather code
                        ForEach(Array(zip(favorites.indices, favorites)), id: \.0) { index, favorite in
                            if let weather = favoriteWeathers[index] {
                                favWeatherView(
                                    weather: weather,
                                    city: favorite.city,
                                    favorite: favorite,
                                    isCurrentLocation: false
                                )
                                .tag(index + 1)
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                    HStack(spacing: 8) {
                        ForEach(0..<(favorites.count + 1), id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.blue : Color.gray)
                                .frame(width: 8, height: 8)
                                .onTapGesture {
                                    currentPage = index
                                }
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
        .onAppear {
            loadCurrentLocationWeather()
            fetchFavorites()
        }
        .onReceive(NotificationCenter.default.publisher(for: .refreshFavorites)) { _ in
            fetchFavorites()
        }

    }

     //Reusable Weather Detail View
        @ViewBuilder
        func weatherDetailView(weather: WeatherData, city: String, isCurrentLocation: Bool) -> some View {
            ScrollView(.horizontal) {
                VStack(spacing: 35) {
                    WeatherCard(
                        weather: weather.current,
                        weatherDetailsDaily: weather.daily_forecast,
                        weatherDataHourly: weather.hourly_forecast,
                        city: city
                    )
    
                    WeatherMetrics(weather: weather.current)
    
                    ForecastView(forecast: weather.daily_forecast)
                }
            }
        }
    
    //Reusable Favourite Weather Detail View
    @ViewBuilder
    func favWeatherView(weather: WeatherData, city: String, favorite: Favorite, isCurrentLocation: Bool) -> some View {
        ScrollView(.horizontal) {
            VStack(spacing: 15) {
                Button(action: {
                    removeFromFavorites(favoriteId: favorite.id)
                                   showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                       showToast = false
                                   }
                    
                }) {
                    Image("close-circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.red)
                }

                .frame(maxWidth: 360, maxHeight: 15, alignment: .topTrailing)

                WeatherCard(
                    weather: weather.current,
                    weatherDetailsDaily: weather.daily_forecast,
                    weatherDataHourly: weather.hourly_forecast,
                    city: city
                )

                WeatherMetrics(weather: weather.current)

                ForecastView(forecast: weather.daily_forecast)
            }

        }
        .overlay(
                // Toast Message
                Group {
                    if showToast {

                        Text("\(city.split(separator: ",").first?.trimmingCharacters(in: .whitespaces) ?? "City") removed from the Favorite List")
                            .font(.body)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .transition(.opacity)
                            .animation(.easeInOut, value: showToast)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .padding(.bottom, 50)
                    }
                }
            )
    }

    func loadCurrentLocationWeather() {
        viewModel.requestCurrentLocationWeather { success in
            if success {
                self.isCurrentLocationLoaded = true
            } else {
                print("Failed to fetch current location weather")
            }
        }
    }

    func fetchFavorites() {
        let url = URL(string: "\(FavoritesService.baseURL)/favorites")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedFavorites = try JSONDecoder().decode([Favorite].self, from: data)
                    DispatchQueue.main.async {
                        self.favorites = decodedFavorites
                        self.favoriteWeathers = Array(repeating: nil, count: decodedFavorites.count)
                        for favorite in decodedFavorites {
                            self.fetchWeatherForFavorite(favorite)
                        }
                    }
                } catch {
                    print("Error decoding favorites: \(error)")
                }
            } else if let error = error {
                print("Error fetching favorites: \(error)")
            }
        }.resume()
    }
    
    func fetchWeatherForFavorite(_ favorite: Favorite) {
        guard let index = favorites.firstIndex(where: { $0.id == favorite.id }) else { return }
        
        fetchCoordinatesGeocode(for: favorite.city) { coordinates in
            guard let coordinates = coordinates else {
                print("Failed to fetch coordinates for \(favorite.city)")
                return
            }
            let weatherUrl = URL(string: "https://weatherappbackend-441501.uw.r.appspot.com/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)")!
            URLSession.shared.dataTask(with: weatherUrl) { data, _, error in
                if let data = data {
                    do {
                        let decodedWeather = try JSONDecoder().decode(WeatherData.self, from: data)
                        DispatchQueue.main.async {
                            self.favoriteWeathers[index] = decodedWeather
                        }
                    } catch {
                        print("Error decoding weather data for favorite: \(error)")
                    }
                } else if let error = error {
                    print("Error fetching weather data for favorite: \(error)")
                }
            }.resume()
        }
    }
    
    
    func fetchCoordinatesGeocode(for city: String, completion: @escaping (Location?) -> Void) {
      let geocodeUrl = "https://maps.googleapis.com/maps/api/geocode/json"
      let fullUrl = "\(geocodeUrl)?address=\(city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city)&key=\(googleApiKey)"

      guard let url = URL(string: fullUrl) else { return }

      URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
          print("Error fetching coordinates: \(error.localizedDescription)")
          completion(nil)
          return
        }

        guard let data = data else {
          print("No data received from API")
          completion(nil)
          return
        }

        do {
          let decodedResponse = try JSONDecoder().decode(GeocodeResponse.self, from: data)
          if let location = decodedResponse.results.first?.geometry.location {
            completion(Location(latitude: location.lat, longitude: location.lng))
          } else {
            print("No coordinates found for \(city)")
            completion(nil)
          }
        } catch {
          print("Error decoding Geocode response: \(error)")
          completion(nil)
        }
      }.resume()
    }
     
    // Remove from Favorites function
    func removeFromFavorites(favoriteId: String) {
        print("Removing favorite with ID: \(favoriteId)")

        // Call backend to remove from favorites
        FavoritesService.removeFavorite(favoriteId: favoriteId) { success in
            if success {
                DispatchQueue.main.async {
                    // Remove the favorite from local array
                    if let index = self.favorites.firstIndex(where: { $0.id == favoriteId }) {
                        self.favorites.remove(at: index)
                        self.favoriteWeathers.remove(at: index)
                    }
                    print("Successfully removed favorite")
                }
            } else {
                DispatchQueue.main.async {
                    print("Failed to remove favorite")
                }
            }
        }
    }
    
    func checkIfFavorited() {
        let url = URL(string: "\(FavoritesService.baseURL)/favorites")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
               
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON: \(jsonString)")
                }
                
                do {
                    let favorites = try JSONDecoder().decode([Favorite].self, from: data)
                    if let existingFavorite = favorites.first(where: { $0.city == viewModel.city }) {
                        DispatchQueue.main.async {
                            isFavorited = true
                            favoriteId = existingFavorite.id
                            print("Favorite ID found: \(existingFavorite.id)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            isFavorited = false
                            favoriteId = nil
                            print("No matching favorite found")
                        }
                    }
                } catch {
                    print("Error decoding favorites: \(error)")
                    // Print out the raw data to help diagnose
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Problematic JSON: \(jsonString)")
                    }
                    DispatchQueue.main.async {
                        isFavorited = false
                        favoriteId = nil
                    }
                }
            } else if let error = error {
                print("Error fetching favorites: \(error)")
                DispatchQueue.main.async {
                    isFavorited = false
                    favoriteId = nil
                }
            }
        }.resume()
    }

}



struct ForecastDay: Decodable, Identifiable {
    let id = UUID()
    let date: String
    let temperature: Double
    let temperature_high: Double
    let temperature_low: Double
    let windSpeed: Double
    let humidity: Double
    let precipitationProbability: Double
    let cloudCover: Double
    let visibility: Double
    let sunriseTime: String
    let sunsetTime: String
    let precipitationType: Double
    let weatherDescription: String
}
struct HourlyData: Decodable, Identifiable {
    let id = UUID()
    let time: String
    let temperature: Double
    let windSpeed: Double
    let pressure: Double
    let precipitationProbability: Double
    let precipitationType: Double
    let humidity: Double
    let windDirection: Double
}
