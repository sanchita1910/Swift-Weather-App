

struct WeatherData: Decodable {
    let current: CurrentWeather
    let daily_forecast: [ForecastDay]
    let hourly_forecast: [HourlyData]
}


struct CurrentWeather: Decodable {
    let temperature: Double
    let humidity: Double
    let windSpeed: Double
    let weatherDescription: String
    let visibility: Double
    let pressure: Double
    let precipitationType: Double
    let windDirection: Double
    let precipitationProbability: Double
    let cloudCover: Double
    let uvIndex: Double
}
struct Location: Equatable {
    var latitude: Double
    var longitude: Double
}


struct AutocompleteResponse: Codable {
    let predictions: [Prediction]
    
    struct Prediction: Codable {
        let description: String
    }
}


struct GeocodeResponse: Codable {
    let results: [Result]
    
    struct Result: Codable {
        let geometry: Geometry
        
        struct Geometry: Codable {
            let location: Location
            
            struct Location: Codable {
                let lat: Double
                let lng: Double
            }
        }
    }
}

