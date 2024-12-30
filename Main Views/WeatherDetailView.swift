import SwiftUI

struct WeatherDetailView: View {
    let weather: CurrentWeather
    let dailyforecast : [ForecastDay]
    let hourData: [HourlyData]
    let city: String
    @State private var selectedTab = 0
    @Environment(\.presentationMode) var presentationMode
    
    // Share on Twitter function
       func shareOnTwitter() {
           let tweetText = """
           The current temperature at \(city) is \(Int(weather.temperature))°F. The weather conditions are \(weather.weatherDescription).
           #CSCI571WeatherForecast
           """
           let tweetUrl = "https://twitter.com/intent/tweet?text=\(tweetText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

           if let url = URL(string: tweetUrl) {
               UIApplication.shared.open(url)
           }
       }
    
    
    var body: some View {
            VStack {
                Spacer()
                
                TabView {
                    // Today Tab
                    TodayView(weather: weather, city: city)
                        .tabItem {
                            Image("Today_Tab")
                            Text("TODAY")
                        }
                    
                    // Weekly Tab
                    WeeklyDetailsView(weather: weather, dailyForecast: dailyforecast)
                        .tabItem {
                            Image("Weekly_Tab")
                            Text("WEEKLY")
                        }
                    
                    // Hourly Tab
                    HourlyView(weather: weather, hourlyData: hourData)
                        .tabItem {
                            Image("Weather_Data_Tab")
                            Text("WEATHER DATA")
                        }
                }
                .frame(maxHeight: .infinity)
            }

            .navigationBarTitle({
                if let cityName = city.split(separator: ",").first?.trimmingCharacters(in: .whitespaces) {
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

        }
}

// Subview for Weather Metric
struct WeatherMetricView: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(.blue)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .font(.system(size: 18))
                .foregroundColor(.black)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
                .frame(height: 160)
                .background(Color.white.opacity(0.4))
                .cornerRadius(15)
                .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white, lineWidth: 1)
                        )
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)

    }
}

// Subview for Action Button
struct WeatherActionButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}
struct TodayView: View {
    let weather: CurrentWeather
    let city: String
    
    
    
        private func weatherImage(for description: String) -> String {

            switch description {
            case "Heavy Rain":
                    return "Heavy Rain" // Image for heavy rain
                case "Rain":
                    return "Rain" // Image for rain
                case "Light Rain":
                    return "Light Rain" // Image for light rain
                case "Heavy Freezing Rain":
                    return "Heavy Freezing Rain" // Image for heavy freezing rain
                case "Freezing Rain":
                    return "Freezing Rain" // Image for freezing rain
                case "Light Freezing Rain":
                    return "Light Freezing Rain" // Image for light freezing rain
                case "Freezing Drizzle":
                    return "Freezing Drizzle" // Image for freezing drizzle
                case "Drizzle":
                    return "Drizzle" // Image for drizzle
                case "Heavy Ice Pellets":
                    return "Heavy Ice Pellets" // Image for heavy ice pellets
                case "Ice Pellets":
                    return "Ice Pellets" // Image for ice pellets
                case "Light Ice Pellets":
                    return "Light Ice Pellets" // Image for light ice pellets
                case "Heavy Snow":
                    return "Heavy Snow" // Image for heavy snow
                case "Snow":
                    return "Snow" // Image for snow
                case "Light Snow":
                    return "Light Snow" // Image for light snow
                case "Flurries":
                    return "Flurries" // Image for flurries
                case "Thunderstorm":
                    return "Thunderstorm" // Image for thunderstorm
                case "Light Fog":
                    return "Light Fog" // Image for light fog
                case "Fog":
                    return "Fog" // Image for fog
                case "Cloudy":
                    return "Cloudy" // Image for cloudy
                case "Mostly Cloudy":
                    return "Mostly Cloudy" // Image for mostly cloudy
                case "Partly Cloudy":
                    return "Partly Cloudy" // Image for partly cloudy
                case "Mostly Clear":
                    return "Mostly Clear" // Image for mostly clear
                case "Clear, Sunny":
                    return "Clear" // Image for clear/sunny
                default:
                    return "Clear" // Default image if description doesn't match
            }
            
        }

        var body: some View {
                ZStack {
                    
                    Image("App_background")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 680)
                        .clipped()
    
                    
                    VStack {
                        Spacer()
                   
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 17) {
                            WeatherMetricView(icon: "WindSpeed", value: "\(weather.windSpeed) mph", label: "Wind Speed")
                            WeatherMetricView(icon: "Pressure", value: "\(weather.pressure) inHg", label: "Pressure")
                            WeatherMetricView(icon: "Precipitation", value: "\(weather.precipitationProbability) %", label: "Precipitation")
                            WeatherMetricView(icon: "Temperature", value: "\(Int(weather.temperature))°F", label: "Temperature")
                            WeatherMetricView(icon: weatherImage(for: weather.weatherDescription), value: weather.weatherDescription.lowercased().contains("clear, sunny") ? "Clear" : weather.weatherDescription, label: "")
                            WeatherMetricView(icon: "Humidity", value: "\(weather.humidity) %", label: "Humidity")
                            WeatherMetricView(icon: "Visibility", value: "\(weather.visibility) mi", label: "Visibility")
                            WeatherMetricView(icon: "CloudCover", value: "\(weather.cloudCover) %", label: "Cloud Cover")
                            WeatherMetricView(icon: "UVIndex", value: "\(weather.uvIndex)", label: "UV Index")
                        }
                        .padding(1)
    
                        Spacer()
                    }

                }
                
            }
}

