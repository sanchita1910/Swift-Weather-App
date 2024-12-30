import SwiftUI
import Highcharts

struct WeeklyDetailsView: View {
    let weather: CurrentWeather
    let dailyForecast: [ForecastDay]
    
    private func weatherImage(for description: String) -> String {
        print("weather data Weekly: \(weather)")
        print("Forecast data: \(dailyForecast)")

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


                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(weatherImage(for: weather.weatherDescription))
                            .resizable()
                            .frame(width: 150, height: 150)
                        
                        VStack(alignment: .leading) {
                            Text(weather.weatherDescription)
                                .font(.system(size: 22))
                                .padding(.bottom, 5)
                            Text("\(Int(weather.temperature))°F")
                                .font(.system(size: 27, weight: .bold))
                                .padding(.bottom, 5)
                           
                        } .padding(.leading, 30)
                    }
                    .padding()
                    .frame(width: 350,height: 170)
                    .background(Color.white.opacity(0.5))
                  
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 1.5)
                            )
                    .padding(.horizontal)
                    
                    
                    HighchartsTemperatureChart(dailyForecast: dailyForecast)
                        .frame(height: 350)
                        .frame(width: 400)
                        .padding(.top, 25)
                }
                .padding(.bottom, 50)
                .frame(width: 200)
            }
        }
    }

    
// UIViewRepresentable for Highcharts
struct HighchartsTemperatureChart: UIViewRepresentable {
    let dailyForecast: [ForecastDay]
    
    private func generateData() -> [[Any]] {
        var data: [[Any]] = []
        let calendar = Calendar.current
        let today = Date()
        guard let start = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: today) else { return data }
        let startTimeInterval = start.timeIntervalSince1970 * 1000
        
        for (index, forecast) in dailyForecast.enumerated() {
            let time = startTimeInterval + Double(index * 24 * 3600 * 1000)
           
            data.append([time,
                         Double(forecast.temperature_high),
                         Double(forecast.temperature_low)])
        }
        return data
    }

    func makeUIView(context: Context) -> HIChartView {
        let chartView = HIChartView(frame: .zero)
        chartView.plugins = ["highcharts-more"]
        
        let chart = HIChart()
        chart.type = "arearange"
        
        let title = HITitle()
        title.text = "Temperature Variation by Day"
        
        let xAxis = HIXAxis()
        xAxis.type = "datetime"

        let dateTimeLabelFormats = HIDateTimeLabelFormats()
        let hiDay = HIDay()
        hiDay.main = "%e %b"
        dateTimeLabelFormats.day = hiDay

        xAxis.dateTimeLabelFormats = dateTimeLabelFormats
        
        let yAxis = HIYAxis()
        yAxis.title = HITitle()
        yAxis.title.text = ""
        
        let tooltip = HITooltip()
        tooltip.shared = NSNumber(value: true)
        tooltip.valueSuffix = "°F"
        
        let legend = HILegend()
        legend.enabled = NSNumber(value: false)
        
        let series = HIArearange()
        series.name = "Temperature Range"
        series.data = generateData()
        series.fillColor = HIColor(linearGradient: ["x1": 0, "y1": 0, "x2": 0, "y2": 1],
                                   stops: [
                                    [0, "rgba(255, 165, 0, 0.5)"],
                                    [1, "rgba(0, 123, 255, 0.5)"]
                                   ])
        series.lineColor = HIColor(name: "gray")
        series.lineWidth = 1
        
        let options = HIOptions()
        options.chart = chart
        options.title = title
        options.xAxis = [xAxis]
        options.yAxis = [yAxis]
        options.tooltip = tooltip
        options.legend = legend
        options.series = [series]
        
        chartView.options = options
        return chartView
    }

    func updateUIView(_ uiView: HIChartView, context: Context) {
       
    }
}
