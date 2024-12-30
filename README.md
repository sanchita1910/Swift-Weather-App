# Swift-Weather-App
This repository contains the code for an iOS weather application built using Swift and Xcode. The app showcases real-time weather information and supports features like location-based updates, favorite city management, and social media sharing using APIs. 
This project emphasizes implementing the Model-View-Controller (MVC) design pattern and integrating third-party libraries using CocoaPods or Swift Package Manager.

Key Features
Weather Details: Displays weather information for the current location and searched cities, including 7-day forecasts.
Search Autocomplete: Supports city search with autocomplete functionality using Tomorrow.io APIs.
Favorites Management: Allows users to save and manage favorite cities, with persistent storage in MongoDB Atlas.
Social Media Integration: Shares weather updates on X (formerly Twitter).
Interactive UI: A polished and user-friendly interface using iOS SDK components like UISearchBar, UITableView, and custom views.
Third-Party Libraries: Utilized libraries like SwiftyJSON, Alamofire, Toast-Swift, SwiftSpinner, and HighCharts for enhanced functionality.
Cloud Backend: Reuses a Node.js backend for API calls and data storage.
Technologies Used
Language: Swift 6
Framework: Cocoa Touch (UIKit), CoreLocation
IDE: Xcode 16.0+
Backend: Node.js with MongoDB Atlas
Libraries:
SwiftyJSON: For handling JSON data
Alamofire: For HTTP requests
Toast-Swift: For notifications
SwiftSpinner: For loading indicators
HighCharts: For data visualization
Installation
Pre-requisites:

macOS with Xcode 16.0+ installed.
CocoaPods or Swift Package Manager for dependency management.
Setup:

Clone the repository:
bash
Copy code
git clone https://github.com/your-username/weather-app-ios.git
cd weather-app-ios
Install dependencies via CocoaPods:
bash
Copy code
pod install
open WeatherApp.xcworkspace
Or via Swift Package Manager:
In Xcode, go to File > Swift Packages > Add Package Dependency.
Add the required libraries using the provided GitHub URLs.
Backend:

Ensure the Node.js backend from Assignment 3 is running for API calls.
Screenshots
Include screenshots of:

Initial View with current location weather.
Search Autocomplete functionality.
Weather Details page with tabs: Today, Weekly, Weather Data.
Favorites Management and X Sharing.
License
This project is licensed under the MIT License. See LICENSE for details.

Feel free to contribute, report issues, or suggest improvements!







