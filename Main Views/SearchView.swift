
import SwiftUI
import CoreLocation

extension Notification.Name {
    static let refreshFavorites = Notification.Name("refreshFavorites")
}

struct SearchView: View {
    @StateObject var viewModel: WeatherViewModel
    @StateObject private var autocompleteViewModel = AutocompleteViewModel()
    @State private var currentWeather: WeatherData?
    @State private var isFavorited: Bool = false
    @State private var favoriteId: String?
    @State private var toastMessage: String?
    @State private var showToast: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.white
                    .frame(height: 5)
                    .ignoresSafeArea()
                
                Image("App_background")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(edges: .bottom)
            }
            
            VStack(spacing: 25) {

                                if isFavorited {
                                    Button(action: removeFromFavorites) {
                                        Image("close-circle")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.red)
                                    }
                                    .padding(15)
                                    .padding(.leading, 1500)
                                    .frame(maxWidth: 370, maxHeight: 20, alignment: .topTrailing)
                                } else {
                                    Button(action: addToFavorites) {
                                        Image("plus-circle")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.blue)
                                    }
                                    .padding(15)
                                    .padding(.leading, 50)
                                    .frame(maxWidth: 370, maxHeight: 20, alignment: .topTrailing)
                                }
                if let weather = viewModel.weather {
                    WeatherCard(weather: weather.current, weatherDetailsDaily: weather.daily_forecast, weatherDataHourly: weather.hourly_forecast, city: viewModel.city)
                    WeatherMetrics(weather: weather.current)
                    ForecastView(forecast: weather.daily_forecast)
                } else {
                    ProgressView()
                    
                }
            }
            
                        if showToast, let message = toastMessage {
                            VStack {
                                Spacer()
                                Text(message)
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.bottom, 50)
                            }
                            .animation(.easeInOut, value: showToast)
                            .transition(.opacity)
                        }
        }

        .navigationBarTitle({
            if let cityName = viewModel.city.split(separator: ",").first?.trimmingCharacters(in: .whitespaces) {
                return cityName
            } else {
                return "Unknown City"
            }
        }(), displayMode: .inline)

            .toolbar {
                
                   ToolbarItem(placement: .navigationBarLeading) {
                       Button(action: {
                           presentationMode.wrappedValue.dismiss()
                       }) {
                           HStack {
                               Image(systemName: "chevron.left")
                                   .font(.system(size: 20, weight: .medium))
                               Text("Weather")
                                   .font(.system(size: 19))
                                   .padding(.trailing, 40)
                           }
                       }
                   }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: shareOnTwitter) {
                        Image("twitter")
                            .font(.title2)
                            .accessibilityLabel("Share on Twitter")
                    }
                }
            }.navigationBarBackButtonHidden(true)
       
            .onAppear {

                if let coordinates = viewModel.coordinates {
                    viewModel.fetchWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    
                }
                checkIfFavorited()
            }                                           
    }
    

    // Add to Favorites function
        func addToFavorites() {
            print("\(viewModel.city) added to favorites")
            

            FavoritesService.addFavorite(city: viewModel.city, state: "State") { success in
                if success {
                    isFavorited = true
                    checkIfFavorited()

                    showToastMessage("\(viewModel.city.split(separator: ",").first?.trimmingCharacters(in: .whitespaces) ?? "City") was added to the Favorite List")

                       NotificationCenter.default.post(name: .refreshFavorites, object: nil)
                } else {
                    print("Failed to add favorite")
                }
            }
        }

    
    // Remove from Favorites function
    func removeFromFavorites() {
        print("Attempting to remove favorite")
        guard let favoriteId = favoriteId else {
            print("favoriteId is nil, cannot remove favorite")
            return
        }

        print("Removing favorite with ID: \(favoriteId)")


        FavoritesService.removeFavorite(favoriteId: favoriteId) { success in
            if success {
                DispatchQueue.main.async {
                    self.isFavorited = false
                    self.favoriteId = nil
                    showToastMessage("\(viewModel.city.split(separator: ",").first?.trimmingCharacters(in: .whitespaces) ?? "City") was removed from the Favorite List")
                    print("Successfully removed favorite")
                    NotificationCenter.default.post(name: .refreshFavorites, object: nil)
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

    
    // Share on Twitter function
       func shareOnTwitter() {
           print(currentWeather)
           let tweetText = """
                     hi
           """
           let tweetUrl = "https://twitter.com/intent/tweet?text=\(tweetText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

           if let url = URL(string: tweetUrl) {
               UIApplication.shared.open(url)
           }
       }
    
    // Toast message helper function
       func showToastMessage(_ message: String) {
           toastMessage = message
           withAnimation {
               showToast = true
           }
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               withAnimation {
                   showToast = false
               }
           }
       }
}

