
import SwiftUI

// Forecast View Component
struct ForecastView: View {
    let forecast: [ForecastDay]
    
    //referred chatgpt
    private func formattedTime(from time: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        outputFormatter.timeZone = .current

        if let date = isoFormatter.date(from: time) {
            return outputFormatter.string(from: date)
        } else {
            print("Failed to format time: \(time)")
            return time
        }
    }

    // Mapping weather description to an image name for display
        private func weatherImage(for description: String) -> String {
            print(forecast)
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
    
        VStack {
            ScrollView {
                ForEach(forecast) { day in
                    HStack {
                        Text(day.date)
                            .frame(width: 100, alignment: .leading)
                        
                        Image(weatherImage(for: day.weatherDescription))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 5) {
                            Image("sun-rise")
                                .foregroundColor(.orange)
                            Text(formattedTime(from: day.sunriseTime))
                                .font(.subheadline)
                                .foregroundColor(.black)
                            
                            Image("sun-set")
                                .foregroundColor(.gray)
                            Text(formattedTime(from: day.sunsetTime)) 
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                }
            }
            .background(Color.white.opacity(0.5))
            .cornerRadius(15)
            .frame(width: 340)
            .padding(.horizontal)
        }.onAppear {
            
        }
    }
    
//    }
}
