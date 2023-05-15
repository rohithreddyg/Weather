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

class WeatherViewModel {
    var city: String?
    var country: String?
    var weatherImage: UIImage?
    var temperature: Double?
    var weatherDescription: String?
    var highTemp: Double?
    var lowTemp: Double?
    var date: Date?
    var humidity: Int?
    var feelsLike: Double?
    var pressure: Int?
    var windSpeed: Double?
    var sunset: Date?
    var timezone: Int?
    var visibility: Int?
    
    var weatherResult: WeatherResult?
    var error: WeatherError?
    var delegate: WeatherViewModelDelegate?
    
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
        temperature = cityWeather.main.temp
        weatherDescription = cityWeather.weather.first?.description.capitalized
        highTemp = cityWeather.main.temp_max
        lowTemp = cityWeather.main.temp_min
        date = Date(timeIntervalSince1970: Double(cityWeather.dt))
        humidity = cityWeather.main.humidity
        feelsLike = cityWeather.main.feels_like
        pressure = cityWeather.main.pressure
        windSpeed = cityWeather.wind.speed
        sunset = Date(timeIntervalSince1970: Double(cityWeather.sys.sunset))
        timezone = cityWeather.timezone
        let visibilityMiles: CGFloat = CGFloat(cityWeather.visibility) / 1609.34
        visibility = Int(visibilityMiles.rounded())

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
    
    private func cacheWeather(weather: Encodable) {
        do {
            try UserDefaults.standard.setObject(weather, forKey: "weather")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getWeatherFromCacheIfAvailable() {
        do {
            weatherResult = try UserDefaults.standard.getObject(forKey: "weather", castTo: WeatherResult.self)
            feedWeatherData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
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
    
    private func calculateGMT(time: Int) -> String {
        let timezone = abs(time) / 3600
        let compare = time > 0 ? "+" : "-"
        if timezone < 10 {
            return "GMT\(compare)0\(timezone)"
        } else {
            return "GMT\(compare)\(timezone)"
        }
    }
    
}
