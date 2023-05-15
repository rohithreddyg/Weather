# Weather App
This is a simple weather app that allows users to search for cities and retrieve weather information using the openweathermap.org API. The app also includes a caching mechanism for weather icons, and auto-loads the last city searched upon app launch. Additionally, users can grant access to their device's location to retrieve weather information by default.

# Features

* Search for cities and retrieve weather information.
* Caching mechanism for weather icons.
* Auto-load the last city searched upon app launch.
* Request location access to retrieve weather information by default.

# Requirements

Xcode 12 or later
iOS 14 or later

# Installation

* Clone the repository:

    git clone https://github.com/rohithreddyg/Weather.git

* Open the project in Xcode.

    cd weather-app
    
    open WeatherApp.xcodeproj

* Run the app on a simulator or physical device.

# Usage

1. Enter a US city in the search bar and tap "Search".
2. The app will retrieve and display weather information for the selected city.
3. The weather icon will be cached for faster loading next time it's requested.
4. If the user grants location access, the app will retrieve weather information based on their current location by default.

# Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
