
import SwiftUI

struct WeatherCard: View {
    let weather: CurrentWeather
    let weatherDetailsDaily : [ForecastDay]
    let weatherDataHourly : [HourlyData]
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
    func getCityName(from description: String) -> String {

        let components = description.split(separator: ",")

        let city = components.first?.trimmingCharacters(in: .whitespaces) ?? ""
        
        return city
    }
    
    var body: some View {

        NavigationLink(destination: WeatherDetailView(weather: weather, dailyforecast: weatherDetailsDaily, hourData: weatherDataHourly, city: city)) {
            VStack(alignment: .leading, spacing: 70) {
                HStack {
                    Image(weatherImage(for: weather.weatherDescription))
                        .resizable()
                        .frame(width: 120, height: 120)
                    
                    VStack(alignment: .leading) {
                        Text("\(Int(weather.temperature))°F")
                            .font(.system(size: 27, weight: .bold))
                            .padding(.bottom,7)
                            .foregroundColor(.black)
                        Text(weather.weatherDescription.lowercased().contains("clear, sunny") ? "Clear" : weather.weatherDescription)
                                               
                            .font(.system(size: 20))
                            .padding(.bottom,7)
                            .foregroundColor(.black)

                        Text(getCityName(from: self.city))
                            .font(.system(size: 25, weight: .bold))
                            .padding(.bottom, 5)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()
            .frame(width: 350,height: 150)
            .background(Color.white.opacity(0.5))
            .cornerRadius(15)
            .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white, lineWidth: 1.5) 
                    )
            .padding(.horizontal)
        }
    }
    
}

