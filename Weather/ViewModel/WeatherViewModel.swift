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

class WeatherViewModel {
    // MARK: - Properties
    var city: String?
    var country: String?
    var weatherImage: UIImage?
    var temperature: String?
    var weatherDescription: String?
    var highTemp: String?
    var lowTemp: String?
    var date: String?
    var humidity: String?
    var feelsLike: String?
    var pressure: String?
    var windSpeed: String?
    var sunset: String?
    var timezone: Int?
    var visibility: String?
    
    var weatherResult: WeatherResult?
    var error: WeatherError?
    var delegate: WeatherViewModelDelegate?
    
    // MARK: - Retrieve Weather Info
    func fetchWeather(text: String?, location: CLLocation?) {
        WeatherService.shared.getWeather(city: text, location: location) { [weak self] weatherResult, error in
            DispatchQueue.main.async {
                
                guard let self = self else {
                    return
                }
                if let error = error {
                    self.error = error
                    self.delegate?.weatherDidReceiveError(error: error)
                }
                guard let cityWeather = weatherResult else {
                    return
                }
                
                self.weatherResult = cityWeather
                self.cacheWeather(weather: cityWeather)
                self.feedWeatherData()
            }
        }
    }
    
    private func feedWeatherData() {
        guard let cityWeather = weatherResult else {
            return
        }
        city = cityWeather.name + ", " + cityWeather.sys.country
        temperature = tempStringFor(temp: cityWeather.main.temp)
        weatherDescription = cityWeather.weather.first?.description.capitalized
        highTemp = "H: \(tempStringFor(temp: cityWeather.main.temp_max))"
        lowTemp = "L: \(tempStringFor(temp: cityWeather.main.temp_min))"
        timezone = cityWeather.timezone
        let dt = Date(timeIntervalSince1970: Double(cityWeather.dt))
        date = getDateTimeFrom(date: dt, timezone: timezone)
        humidity = "\(cityWeather.main.humidity)%"
        feelsLike = tempStringFor(temp: cityWeather.main.feels_like)
        pressure = pressureInHgFrom(pressure: cityWeather.main.pressure)
        windSpeed = "\(cityWeather.wind.speed) mph"
        let sunsetTime = Date(timeIntervalSince1970: Double(cityWeather.sys.sunset))
        sunset = getHourStringFrom(date: sunsetTime, timezone: timezone)
        let visibilityMiles: CGFloat = CGFloat(cityWeather.visibility) / 1609.34
        visibility = "\(Int(visibilityMiles.rounded())) mi"

        if let icon = cityWeather.weather.first?.icon {
            if let imageData = UserDefaults.standard.value(forKey: icon) {
                let image = UIImage(data: imageData as! Data)
                self.weatherImage = image
            } else {
                WeatherService.shared.getWeatherIcon(icon: icon) { image, errorMessage in
                    if let image = image {
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
            weatherResult = try UserDefaults.standard.getObject(forKey: keyLastSavedWeather, castTo: WeatherResult.self)
            feedWeatherData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Helper Functions
    func tempStringFor(temp: Double) -> String {
        return "\(Int(temp.rounded()))ºF"
    }
    
    func pressureInHgFrom(pressure: Int) -> String {
        let preInHg: Double = Double(pressure) * 0.029529983071445
        let string = String(format: "%.2f inHg", preInHg)
        return string
    }
    
    func getHourStringFrom(date: Date, timezone: Int? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        if let timezone = timezone {
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
        if let timezone = timezone {
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
