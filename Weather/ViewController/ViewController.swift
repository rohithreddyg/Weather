//
//  ViewController.swift
//  Weather
//
//  Created by Rohith Reddy Gurram on 5/14/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var temperatureStackView: WeatherStackView!
    @IBOutlet weak var humidityStackView: UIStackView!
    @IBOutlet weak var feelsLikeStackView: UIStackView!
    @IBOutlet weak var pressureStackView: UIStackView!
    @IBOutlet weak var sunsetStackView: UIStackView!
    @IBOutlet weak var windSpeedStackView: UIStackView!
    @IBOutlet weak var visibilityStackView: UIStackView!
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    
    // MARK: - Properties
    var weatherViewModel: WeatherViewModel?
    var locationService: LocationService?
    
    // MARK: - View Lyfe Cycle Method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel = WeatherViewModel()
        weatherViewModel?.delegate = self
        weatherViewModel?.getWeatherFromCacheIfAvailable()
        locationService = LocationService()
        startLocationService()
        configureView()
    }
    
    // MARK: - Private functions
    private func startLocationService() {
        locationService?.delegate = self
        locationService?.requestLocation()
    }
        
    private func configureView() {
        toggleVisibility(of: temperatureStackView, for: weatherViewModel)

        guard let weatherViewModel = weatherViewModel else {
            showAlert(message: "")
            return
        }
        
        if let error = weatherViewModel.error {
            print(error.errorDescription)
            showAlert(message: error.message)
            return
        }
        
        if let city = weatherViewModel.city {
            cityLabel.text = city
        }
        toggleVisibility(of: cityLabel, for: weatherViewModel.city)
        
        if let image = weatherViewModel.weatherImage {
            weatherImageView.image = image
        }
        toggleVisibility(of: weatherImageView, for: weatherViewModel.weatherImage)
        
        if let temp = weatherViewModel.temperature {
            temperatureLabel.text = temp
        }
        toggleVisibility(of: temperatureLabel, for: weatherViewModel.temperature)
        
        if let desc = weatherViewModel.weatherDescription {
            descriptionLabel.text = desc
        }
        toggleVisibility(of: descriptionLabel, for: weatherViewModel.weatherDescription)
        
        if let high = weatherViewModel.highTemp,
           let low = weatherViewModel.lowTemp {
            highTempLabel.text = high
            lowTempLabel.text = low
        }
        toggleVisibility(of: highTempLabel, for: weatherViewModel.highTemp)
        toggleVisibility(of: lowTempLabel, for: weatherViewModel.lowTemp)
        
        if let dt = weatherViewModel.date {
            dateLabel.text = dt
        }
        toggleVisibility(of: dateLabel, for: weatherViewModel.date)
        
        
        if let humidity = weatherViewModel.humidity {
            humidityLabel.text = humidity
        }
        toggleVisibility(of: humidityStackView, for: weatherViewModel.humidity)
        
        if let feelsLike = weatherViewModel.feelsLike {
            feelsLikeLabel.text = feelsLike
        }
        toggleVisibility(of: feelsLikeStackView, for: weatherViewModel.feelsLike)
        
        if let pressure = weatherViewModel.pressure {
            pressureLabel.text = pressure
        }
        toggleVisibility(of: pressureStackView, for: weatherViewModel.pressure)
        
        if let sunset = weatherViewModel.sunset {
            sunsetLabel.text = sunset
        }
        toggleVisibility(of: sunsetStackView, for: weatherViewModel.sunset)
        
        if let windSpeed = weatherViewModel.windSpeed {
            windSpeedLabel.text = windSpeed
        }
        toggleVisibility(of: windSpeedStackView, for: weatherViewModel.windSpeed)
        
        if let visibility = weatherViewModel.visibility {
            visibilityLabel.text = visibility
        }
        toggleVisibility(of: visibilityStackView, for: weatherViewModel.visibility)
    }
    
    private func toggleVisibility(of view: UIView, for value: Any?) {
        view.isHidden = (value != nil) ? false : true
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let negativeAction = UIAlertAction(title: "OK", style: .cancel) { action in
            alert.dismiss(animated: true)
        }
        alert.addAction(negativeAction)
        weatherViewModel?.error = nil
        self.present(alert, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text,
           !text.isEmpty {
            weatherViewModel?.fetchWeather(text: text, location: nil)
            configureView()
        }
        return true
    }
}

extension ViewController: LocationServiceDelegate {
    func locationDidUpdate(_ service: LocationService, location: CLLocation) {
        weatherViewModel?.fetchWeather(text: nil, location: location)
    }
    
    func locationDidFail(withError error: WeatherError) {
        weatherViewModel?.error = error
    }
}

extension ViewController: WeatherViewModelDelegate {
    func weatherDidUpdate() {
        configureView()
    }
    
    func weatherDidReceiveError(error: WeatherError) {
        print(error.errorDescription)
        showAlert(message: error.message)
    }
}

