//
//  WeatherService.swift
//  Weather
//
//  Created by Rohith Reddy Gurram on 5/14/23.
//

import Foundation
import CoreLocation
import UIKit

typealias WeatherCompletionHandler = (WeatherResult?, WeatherError?) -> Void
typealias ImageCompletionHandler = (UIImage?, WeatherError?) -> Void

class WeatherService {
    static let shared = WeatherService()
    
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
    let apiKey = "6aeb43ef4d51a6a4d3195cd4c39491d8"
    let session = URLSession(configuration: .default)
    
    private func buildWeatherUrlString(city: String?, location: CLLocation?) -> String {
        var URL_PARAMS = ""
        if let location = location {
            URL_PARAMS = "lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
        } else {
            URL_PARAMS = "q=" + city!
        }
        return baseUrl + URL_PARAMS + "&appid=" + apiKey + "&units=imperial"
    }
    
    func getWeather(city: String?, location: CLLocation?, completion: @escaping WeatherCompletionHandler) {
        let urlString = buildWeatherUrlString(city: city, location: location)
        
        guard let url = URL(string: urlString) else {
            completion(nil, WeatherError.invalidUrl)
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
                if let _ = error {
                    completion(nil, WeatherError.networkFailed)
                    return
                }
                
                guard let data = data,
                      let _ = response as? HTTPURLResponse else {
                    completion(nil, WeatherError.jsonSerializationFailed)
                    return
                }
                
            do {
                let items = try JSONDecoder().decode(WeatherResult.self, from: data)
                completion(items, nil)
            } catch {
                    completion(nil, WeatherError.jsonParsingFailed)
                }
        }
        task.resume()
    }
    
    func getWeatherIcon(icon: String, completion: @escaping (ImageCompletionHandler)) {
        let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        
        guard let url = URL(string: urlString) else {
            completion(nil, WeatherError.invalidUrl)
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(nil, WeatherError.networkFailed)
                    return
                }
                
                guard let imageData = data,
                      let _ = response as? HTTPURLResponse else {
                    completion(nil, WeatherError.jsonSerializationFailed)
                    return
                }
                
                if let downloadedImage = UIImage(data: imageData) {
                    completion(downloadedImage, nil)
                } else {
                    completion(nil, WeatherError.jsonParsingFailed)
                }
            }
        }
        
        task.resume()
    }
    
}
