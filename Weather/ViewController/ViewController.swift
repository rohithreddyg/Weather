//
//  ViewController.swift
//  Weather
//
//  Created by Rohith Reddy Gurram on 5/14/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
    
    var weatherViewModel: WeatherViewModel?
    var locationService: LocationService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel = WeatherViewModel()
        weatherViewModel?.delegate = self
        weatherViewModel?.getWeatherFromCacheIfAvailable()
        locationService = LocationService()
        startLocationService()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        view.applyGradientLayer()
    }
    
    private func configureView() {
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
            cityLabel.isHidden = false
            cityLabel.text = city
        } else {
            cityLabel.isHidden = true
        }
        if let image = weatherViewModel.weatherImage {
            weatherImageView.isHidden = false
            weatherImageView.image = image
        } else {
            weatherImageView.isHidden = true
        }
        if let temp = weatherViewModel.temperature {
            temperatureLabel.isHidden = false
            temperatureLabel.text = weatherViewModel.tempStringFor(temp: temp)
        } else {
            temperatureLabel.isHidden = true
        }
        if let desc = weatherViewModel.weatherDescription {
            descriptionLabel.isHidden = false
            descriptionLabel.text = desc
        } else {
            descriptionLabel.isHidden = true
        }
        if let high = weatherViewModel.highTemp,
           let low = weatherViewModel.lowTemp {
            highTempLabel.isHidden = false
            lowTempLabel.isHidden = false
            highTempLabel.text = "H: \(weatherViewModel.tempStringFor(temp: high))"
            lowTempLabel.text = "L: \(weatherViewModel.tempStringFor(temp: low))"
        } else {
            highTempLabel.isHidden = true
            lowTempLabel.isHidden = true
        }
        if let dt = weatherViewModel.date {
            dateLabel.isHidden = false
            dateLabel.text = weatherViewModel.getDateTimeFrom(date: dt, timezone: timezone)
        } else {
            dateLabel.isHidden = true
        }
        
        if let humidity = weatherViewModel.humidity {
            humidityStackView.isHidden = false
            humidityLabel.text = "\(humidity)%"
        } else {
            humidityStackView.isHidden = true
        }
        if let feelsLike = weatherViewModel.feelsLike {
            feelsLikeStackView.isHidden = false
            feelsLikeLabel.text = weatherViewModel.tempStringFor(temp: feelsLike)
        } else {
            feelsLikeStackView.isHidden = true
        }
        if let pressure = weatherViewModel.pressure {
            pressureStackView.isHidden = false
            pressureLabel.text = weatherViewModel.pressureInHgFrom(pressure: pressure)
        } else {
            pressureStackView.isHidden = true
        }
        if let sunset = weatherViewModel.sunset {
            sunsetStackView.isHidden = false
            sunsetLabel.text = weatherViewModel.getHourStringFrom(date: sunset, timezone: timezone)
        } else {
            sunsetStackView.isHidden = true
        }
        if let windSpeed = weatherViewModel.windSpeed {
            windSpeedStackView.isHidden = false
            windSpeedLabel.text = "\(windSpeed) mph"
        } else {
            windSpeedStackView.isHidden = true
        }
        if let visibility = weatherViewModel.visibility {
            visibilityStackView.isHidden = false
            visibilityLabel.text = "\(visibility) mi"
        } else {
            visibilityStackView.isHidden = true
        }
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
    
    func startLocationService() {
        locationService?.delegate = self
        locationService?.requestLocation()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
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
