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
        toggleVisibility(of: temperatureStackView, for: weatherViewModel?.city ?? "")
        
        guard let weatherViewModel else {
            showAlert(message: "")
            return
        }
        
        if let error = weatherViewModel.error {
            print(error.errorDescription)
            showAlert(message: error.message)
            return
        }
        
        cityLabel.text = weatherViewModel.city
        toggleVisibility(of: cityLabel, for: weatherViewModel.city)
        
        if let image = weatherViewModel.weatherImage {
            weatherImageView.isHidden = false
            weatherImageView.image = image
        } else {
            weatherImageView.isHidden = true
        }
        
        temperatureLabel.text = weatherViewModel.temperature
        toggleVisibility(of: temperatureLabel, for: weatherViewModel.temperature)
        
        descriptionLabel.text = weatherViewModel.weatherDescription
        toggleVisibility(of: descriptionLabel, for: weatherViewModel.weatherDescription)
        
        highTempLabel.text = weatherViewModel.highTemp
        lowTempLabel.text = weatherViewModel.lowTemp
        toggleVisibility(of: highTempLabel, for: weatherViewModel.highTemp)
        toggleVisibility(of: lowTempLabel, for: weatherViewModel.lowTemp)
        
        dateLabel.text = weatherViewModel.date
        toggleVisibility(of: dateLabel, for: weatherViewModel.date)
        
        humidityLabel.text = weatherViewModel.humidity
        toggleVisibility(of: humidityStackView, for: weatherViewModel.humidity)
        
        feelsLikeLabel.text = weatherViewModel.feelsLike
        toggleVisibility(of: feelsLikeStackView, for: weatherViewModel.feelsLike)
        
        pressureLabel.text = weatherViewModel.pressure
        toggleVisibility(of: pressureStackView, for: weatherViewModel.pressure)
        
        sunsetLabel.text = weatherViewModel.sunset
        toggleVisibility(of: sunsetStackView, for: weatherViewModel.sunset)
        
        windSpeedLabel.text = weatherViewModel.windSpeed
        toggleVisibility(of: windSpeedStackView, for: weatherViewModel.windSpeed)
        
        visibilityLabel.text = weatherViewModel.visibility
        toggleVisibility(of: visibilityStackView, for: weatherViewModel.visibility)
    }
    
    private func toggleVisibility(of view: UIView, for value: String) {
        view.isHidden = value.isEmpty
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

