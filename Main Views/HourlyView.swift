
import SwiftUI
import Highcharts

struct HourlyView: View {
    let weather: CurrentWeather
    let hourlyData: [HourlyData]
    
    private func weatherImage(for description: String) -> String {
        print("weather data Weekly: \(weather)")
        print("Hour data: \(hourlyData)")

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
                        VStack(alignment: .leading) {
                            HStack {
                                                       Image("Precipitation")
                                                           .resizable()
                                                           .frame(width: 35, height: 35)
                                Text("Precipitation :  ")
                                    .font(.system(size: 17, weight: .bold))
                                                       Text("\(Int(weather.precipitationProbability)) %")
                                                           .font(.system(size: 17, weight: .bold))
                                                   }
                                                   HStack {
                                                       Image("Humidity")
                                                           .resizable()
                                                           .frame(width: 35, height: 35)
                                                       Text("Humiidty :  ")
                                                           .font(.system(size: 17, weight: .bold))
                                                       Text("\(Int(weather.humidity)) %")
                                                           .font(.system(size: 17, weight: .bold))
                                                   }
                                                   HStack {
                                                       Image("CloudCover")
                                                           .resizable()
                                                           .frame(width: 35, height: 35)
                                                       Text("Cloud Cover :  ")
                                                           .font(.system(size: 17, weight: .bold))
                                                       Text("\(Int(weather.cloudCover)) %")
                                                           .font(.system(size: 17, weight: .bold))
                                                   }
                        }
                    }
                    .padding()
                    .frame(width: 350, height: 180)
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(15)
                    .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 1.5)
                            )
                    .padding(.horizontal)
                    
                
                                    HighchartView(weather: weather)
                                        .frame(height: 400)
                                        .padding(.top, 5)
                }
                .padding()
            }
        }
    }
struct HighchartView: UIViewRepresentable {
    let weather: CurrentWeather
    func makeUIView(context: Context) -> HIChartView {
        let chartView = HIChartView()
        chartView.plugins = ["solid-gauge"]
        
        let options = HIOptions()

        let chart = HIChart()
        chart.type = "solidgauge"
        chart.height = "110%"
        options.chart = chart

        let title = HITitle()
        title.text = "Weather Data"
        title.style = HICSSObject()
        title.style.fontSize = "24px"
        options.title = title

        let tooltip = HITooltip()
        tooltip.borderWidth = 0
        tooltip.shadow = HIShadowOptionsObject()
        tooltip.shadow.opacity = 0
        tooltip.style = HICSSObject()
        tooltip.style.fontSize = "16px"
        tooltip.valueSuffix = "%"
        tooltip.pointFormat = "{series.name}<br><span style=\"font-size:2em; color: {point.color}; font-weight: bold\">{point.y}</span>"
        tooltip.positioner = HIFunction(jsFunction: "function (labelWidth) { return { x: (this.chart.chartWidth - labelWidth) / 2, y: (this.chart.plotHeight / 2) + 15 }; }")
        options.tooltip = tooltip

        let pane = HIPane()
        pane.startAngle = 0
        pane.endAngle = 360

        let background1 = HIBackground()
        background1.backgroundColor =  HIColor(rgba: 144, green: 238, blue: 144, alpha: 0.35) // Green for outermost ring
        background1.outerRadius = "112%"
        background1.innerRadius = "88%"
        background1.borderWidth = 0

        let background2 = HIBackground()
        background2.backgroundColor = HIColor(rgba: 173, green: 216, blue: 230, alpha: 0.35) // Light Blue for middle ring
        background2.outerRadius = "87%"
        background2.innerRadius = "63%"
        background2.borderWidth = 0

        let background3 = HIBackground()
        background3.backgroundColor = HIColor(rgba: 255, green: 182, blue: 193, alpha: 0.35) // Pink for innermost ring
        background3.outerRadius = "62%"
        background3.innerRadius = "38%"
        background3.borderWidth = 0

        pane.background = [background1, background2, background3]
        options.pane = pane

        let yAxis = HIYAxis()
        yAxis.min = 0
        yAxis.max = 100
        yAxis.lineWidth = 0
        yAxis.tickWidth = 0 // Disable major ticks
        yAxis.minorTickWidth = 0 // Disable minor ticks
        yAxis.tickPosition = "" // Ensure no tick marks are rendered
        // Disable tick labels (numbers)
        let yAxisLabels = HILabels()
        yAxisLabels.enabled = false
        yAxis.labels = yAxisLabels
        options.yAxis = [yAxis]

        let plotOptions = HIPlotOptions()
        plotOptions.solidgauge = HISolidgauge()
        
        // Remove data labels
        let dataLabels = HIDataLabels()
        dataLabels.enabled = false
        plotOptions.solidgauge.dataLabels = [dataLabels]
        
        plotOptions.solidgauge.linecap = "round"
        plotOptions.solidgauge.stickyTracking = false
        plotOptions.solidgauge.rounded = true
        options.plotOptions = plotOptions

        // Set up series data for each gauge
        let move = HISolidgauge()
        move.name = "Cloud Cover"
        let moveData = HIData()
        moveData.color = HIColor(rgba: 144, green: 238, blue: 144, alpha: 1) // Green color for Stand section
//        HIColor(rgba: 106, green: 165, blue: 231, alpha: 1) // Light Blue color for Move section
        moveData.radius = "112%"
        moveData.innerRadius = "88%"
        moveData.y = NSNumber(value: weather.cloudCover)
        move.data = [moveData]

        let exercise = HISolidgauge()
        exercise.name = "Precipitation"
        let exerciseData = HIData()
        exerciseData.color =  HIColor(rgba: 106, green: 165, blue: 231, alpha: 1) // Light Blue color for Move section
//        HIColor(rgba: 255, green: 182, blue: 193, alpha: 1) // Pink color for Exercise section
        exerciseData.radius = "87%"
        exerciseData.innerRadius = "63%"
        exerciseData.y = NSNumber(value: weather.precipitationProbability)
        exercise.data = [exerciseData]
        

        let stand = HISolidgauge()
        stand.name = "Humidity"
        let standData = HIData()
        standData.color = HIColor(rgba: 255, green: 182, blue: 193, alpha: 1) // Pink color for Exercise section
//        HIColor(rgba: 106, green: 165, blue: 231, alpha: 1) // Light Blue color for Move section
//        HIColor(rgba: 144, green: 238, blue: 144, alpha: 1) // Green color for Stand section
        standData.radius = "62%"
        standData.innerRadius = "38%"
        standData.y = NSNumber(value: weather.humidity)
        stand.data = [standData]

        options.series = [move, exercise, stand]

        chartView.options = options
        
        return chartView
    }

    func updateUIView(_ uiView: HIChartView, context: Context) {
        
    }
}
