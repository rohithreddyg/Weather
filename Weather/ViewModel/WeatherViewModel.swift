//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Rohith Reddy Gurram on 5/14/23.
//

import Foundation
import UIKit
import CoreLocation

protocol WeatherViewModelDelegate {
    func weatherDidUpdate()
    func weatherDidReceiveError(error: WeatherError)
}

let keyLastSavedWeather = "lastSavedWeather"
let mtsToMiles = 1609.34
let milesPerHourString = "mph"
let mileString = "mi"

class WeatherViewModel {
    // MARK: - Properties
    var city = ""
    var country = ""
    var weatherImage: UIImage?
    var temperature = ""
    var weatherDescription = ""
    var highTemp = ""
    var lowTemp = ""
    var date = ""
    var humidity = ""
    var feelsLike = ""
    var pressure = ""
    var windSpeed = ""
    var sunset = ""
    var visibility = ""
    
    var error: WeatherError?
    var delegate: WeatherViewModelDelegate?
    
    // MARK: - Retrieve Weather Info
    func fetchWeather(text: String?, location: CLLocation?) {
        WeatherService.shared.getWeather(city: text, location: location) { [weak self] weatherResult, error in
            DispatchQueue.main.async {
                guard let self else { return }
                
                if let error {
                    self.error = error
                    self.delegate?.weatherDidReceiveError(error: error)
                }
                
                guard let cityWeather = weatherResult else { return }
                
                self.cacheWeather(weather: cityWeather)
                self.feedWeatherData(weatherResult: cityWeather)
            }
        }
    }
    
    /// Converts WeatherResult struct into WeatherViewModel
    private func feedWeatherData(weatherResult: WeatherResult) {
        city = weatherResult.name + ", " + weatherResult.sys.country
        temperature = tempStringFor(temp: weatherResult.main.temp)
        weatherDescription = (weatherResult.weather.first?.description.capitalized)!
        highTemp = "H: \(tempStringFor(temp: weatherResult.main.tempMax))"
        lowTemp = "L: \(tempStringFor(temp: weatherResult.main.tempMin))"
        let timezone = weatherResult.timezone
        let dt = Date(timeIntervalSince1970: Double(weatherResult.dt))
        date = getDateTimeFrom(date: dt, timezone: timezone)
        humidity = "\(weatherResult.main.humidity)%"
        feelsLike = tempStringFor(temp: weatherResult.main.feelsLike)
        pressure = pressureInHgFrom(pressure: weatherResult.main.pressure)
        windSpeed = "\(weatherResult.wind.speed) \(milesPerHourString)"
        let sunsetTime = Date(timeIntervalSince1970: Double(weatherResult.sys.sunset))
        sunset = getHourStringFrom(date: sunsetTime, timezone: timezone)
        let visibilityMiles: CGFloat = CGFloat(weatherResult.visibility) / mtsToMiles
        visibility = "\(Int(visibilityMiles.rounded())) \(mileString)"

        if let icon = weatherResult.weather.first?.icon {
            if let imageData = UserDefaults.standard.value(forKey: icon) {
                let image = UIImage(data: imageData as! Data)
                self.weatherImage = image
            } else {
                WeatherService.shared.getWeatherIcon(icon: icon) { image, errorMessage in
                    if let image {
                        let imageData = image.pngData()
                        UserDefaults.standard.setValue(imageData, forKey: icon)
                        self.weatherImage = image
                    }
                }
            }
        }
        
        delegate?.weatherDidUpdate()
        
    }
    
    // MARK: - Caching Functions
    private func cacheWeather(weather: Encodable) {
        do {
            try UserDefaults.standard.setObject(weather, forKey: keyLastSavedWeather)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getWeatherFromCacheIfAvailable() {
        do {
            let weatherResult = try UserDefaults.standard.getObject(forKey: keyLastSavedWeather, castTo: WeatherResult.self)
            feedWeatherData(weatherResult: weatherResult)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Helper Functions
    /// Exposing these functions just for testing.
    func tempStringFor(temp: Double) -> String {
        return "\(Int(temp.rounded()))ºF"
    }
    
    /// Converts Pressure from Hpa(hectopascal) to inHg(inches of Mercury)
    func pressureInHgFrom(pressure: Int) -> String {
        let preInHg: Double = Double(pressure) * 0.029529983071445
        let string = String(format: "%.2f inHg", preInHg)
        return string
    }
    
    func getHourStringFrom(date: Date, timezone: Int? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        if let timezone {
            dateFormatter.timeZone = TimeZone(abbreviation: calculateGMT(time: timezone))
        }
        var string = dateFormatter.string(from: date)
        if string.last == "M" {
            string = String(string.prefix(string.count-3))
        }
        return string
    }
    
    func getDateTimeFrom(date: Date, timezone: Int? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        if let timezone {
            dateFormatter.timeZone = TimeZone(abbreviation: calculateGMT(time: timezone))
        }
        let string = dateFormatter.string(from: date)
        return string
    }
    
    func calculateGMT(time: Int) -> String {
        let timezone = abs(time) / 3600
        let compare = time > 0 ? "+" : "-"
        if timezone < 10 {
            return "GMT\(compare)0\(timezone)"
        } else {
            return "GMT\(compare)\(timezone)"
        }
    }
    
}
