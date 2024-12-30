import SwiftUI
import SwiftSpinner

@main
struct WeatherAppIOSApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
        }
    }
}

struct LaunchView: View {
    @State private var isTimerDone = false
    
    var body: some View {
        if isTimerDone {
           
            MainWeatherView()
        } else {
            ZStack {
                
                Image("App_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

               
                VStack {
                   
                    Image("Mostly Clear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    
                    Spacer().frame(height: 50)
                    
                    
                    Image("Powered_by_Tomorrow-Black")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
            }
            .onAppear {
                
                                
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    SwiftSpinner.show("Fetching data for current location...")
                                   
                                    SwiftSpinner.hide()
                                    
                                    
                                    isTimerDone = true
                                }

            }
        }
    }
}
