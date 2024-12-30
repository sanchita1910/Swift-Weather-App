
import SwiftUI


struct WeatherMetrics: View {
    let weather: CurrentWeather
    
    var body: some View {
        HStack(spacing: 20) {
            MetricItem(icon: "Humidity", value: "\(Int(weather.humidity))%", title: "Humidity")
            MetricItem(icon: "WindSpeed", value: "\(String(format: "%.2f", weather.windSpeed)) mph", title: "Wind Speed")
            MetricItem(icon: "Visibility", value: "\(String(format: "%.2f", weather.visibility)) mi", title: "Visibility")
            MetricItem(icon: "Pressure", value: "\(String(format: "%.2f", weather.pressure)) inHg", title: "Pressure")
        }
        .padding()
        .frame(height: 150)
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

// Individual Metric Item Component
struct MetricItem: View {
    let icon: String
    let value: String
    let title: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 15))
                .padding(.bottom, 5)
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding(.bottom, 6)
                .padding(.top, 2)
            Text(value)
                .font(.system(size: 18))

            
        }
    }
}
