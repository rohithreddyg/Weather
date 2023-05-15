//
//  WeatherView.swift
//  Weather
//
//  Created by Rohith Reddy Gurram on 5/14/23.
//

import Foundation
import UIKit

@IBDesignable
class WeatherView: UIView {
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.customizeView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    func customizeView() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.cornerRadius = 10
        gradient.borderWidth = 1
        
        let color1 = UIColor(red: 255/255.0, green: 230/255.0, blue: 250/255.0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 50/255.0, green: 150/255.0, blue: 230/255.0, alpha: 1.0).cgColor
        
        gradient.colors = [color1, color2]
        
        layer.insertSublayer(gradient, at: 0)
    }

}

@IBDesignable
class WeatherStackView: UIStackView {
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.customizeView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    func customizeView() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.cornerRadius = 10
        gradient.borderWidth = 1
        
        let color1 = UIColor(red: 50/255.0, green: 150/255.0, blue: 230/255.0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 255/255.0, green: 230/255.0, blue: 250/255.0, alpha: 1.0).cgColor
        
        gradient.colors = [color1, color2]
        
        layer.insertSublayer(gradient, at: 0)
    }

}
