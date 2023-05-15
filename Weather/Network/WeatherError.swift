//
//  WeatherError.swift
//  Weather
//
//  Created by Rohith Reddy Gurram on 5/14/23.
//

import Foundation

enum WeatherError: LocalizedError {
    case invalidUrl
    case networkFailed
    case jsonSerializationFailed
    case jsonParsingFailed
    case unableToFindLocation
    
    var errorDescription: String {
        switch self {
        case .invalidUrl:
            return "Error building URL"
        case .networkFailed:
            return "Network failed"
        case .jsonParsingFailed:
            return "Could not decode the weather data"
        case .jsonSerializationFailed:
            return "Invalid data from the weather service"
        case .unableToFindLocation:
            return "Unable to find the user's location"
        }
    }
    
    var message: String {
        switch self {
        case .invalidUrl:
            return "Invalid City name. Please try again."
        case .networkFailed:
            return "We are having trouble connecting to the weather service. Please try later."
        case .jsonParsingFailed, .jsonSerializationFailed:
            return "Something went wrong. Please try later."
        case .unableToFindLocation:
            return "We are unable to find your location. Please check the location permissions again."
        }
    }
}
