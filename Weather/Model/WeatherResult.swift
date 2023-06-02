//
//  WeatherResult.swift
//  Weather
//
//  Created by Rohith Reddy Gurram on 5/14/23.
//

import Foundation

struct WeatherResult: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    let rain: Rain?
    let snow: Snow?
    
    enum CodingKeys: String, CodingKey {
        case coord
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case dt
        case sys
        case timezone
        case id
        case name
        case cod
        case rain
        case snow
    }
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let feelsLike: Double
    let seaLevel: Int?
    let grndLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
        case feelsLike = "feels_like"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Rain: Codable {
    let oneHour: Double?
    let threeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHour = "3h"
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed
        case deg
        case gust
    }
}

struct Clouds: Codable {
    let all: Int
}

struct Snow: Codable {
    let oneHour: Double?
    let threeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHour = "3h"
    }
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}
