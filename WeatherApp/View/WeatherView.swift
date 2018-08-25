//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 21.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    @IBOutlet private var labelsCollection: [UILabel]!
    @IBOutlet private weak var cancelButtonConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchTextFieldConstarint: NSLayoutConstraint!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var backgroundLabel: UIImageView!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var searchTextField: UITextField!
    
    var searchInputText: String? {
        return (searchTextField.text != "" ? searchTextField.text! : "")
    }
    
    var gradientLayer: CAGradientLayer! {
        didSet {
            gradientLayer.startPoint = CGPoint(x: 1, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            let startColor = #colorLiteral(red: 0.4960681425, green: 0.9903081546, blue: 1, alpha: 1).cgColor
            let endColor = #colorLiteral(red: 0.2947610014, green: 0.3120096294, blue: 1, alpha: 1).cgColor
            gradientLayer.colors = [startColor, endColor]
        }
    }
    
    
    
    
    
    // MARK: - Animation methods
    
    func animateCancelButtonAppearing() {
        cancelButtonConstraint.constant = 20
        searchTextFieldConstarint.constant = 70
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    
    func animateCancelButtonDisappearing() {
        cancelButtonConstraint.constant = -30
        searchTextFieldConstarint.constant = 30
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        searchTextField.resignFirstResponder()
    }
    
    
    func hideCancelButton() {
        cancelButtonConstraint.constant = -30.0
    }
    

    
    
    
    // MARK: - Updating UI methods
    
     private func updateTextColor(accordingToThe weatherType: WeatherType) {
        var textColor: UIColor!
        switch weatherType {
        case .night:
            textColor = #colorLiteral(red: 0.932541154, green: 0.9426591571, blue: 0.9730131662, alpha: 1)
        case .rain:
            textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .snow:
            textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        case .sun:
            textColor = #colorLiteral(red: 0.2247636259, green: 0.6044217707, blue: 0.9357911585, alpha: 1)
        case .cloud:
            textColor = #colorLiteral(red: 0.3223756163, green: 0.3598257331, blue: 0.5669975354, alpha: 1)
        case .fog:
            textColor = #colorLiteral(red: 0.09881003953, green: 0.3102670464, blue: 0.4297801118, alpha: 1)
        default: break
        }
        
        for label in labelsCollection {
            label.textColor = textColor
        }
        
    }
    
    
    private func updateGradientLayerColor(accordingToThe weatherType: WeatherType) {
        
        switch weatherType {
        case .night:
            let startColor = #colorLiteral(red: 0.2601886894, green: 0.03777104234, blue: 0.9300047589, alpha: 1).cgColor
            let endColor = #colorLiteral(red: 0.07588435914, green: 0.07588435914, blue: 0.07588435914, alpha: 1).cgColor
            gradientLayer.colors = [startColor, endColor]
        case .rain:
            let startColor = #colorLiteral(red: 0.6522594229, green: 0.787078842, blue: 0.954988896, alpha: 1).cgColor
            let endColor = #colorLiteral(red: 0.2247636259, green: 0.6044217707, blue: 0.9357911585, alpha: 1).cgColor
            gradientLayer.colors = [startColor, endColor]
        case .snow:
            let startColor = #colorLiteral(red: 0.8982061285, green: 0.9866463658, blue: 1, alpha: 1).cgColor
            let endColor = #colorLiteral(red: 0.5569713361, green: 0.8328593017, blue: 0.9686274529, alpha: 1).cgColor
            gradientLayer.colors = [startColor, endColor]
        case .sun:
            let startColor = #colorLiteral(red: 0.9636427775, green: 0.9764705896, blue: 0.2492979601, alpha: 1).cgColor
            let endColor = #colorLiteral(red: 1, green: 0.9630325109, blue: 0.4874781324, alpha: 1).cgColor
            gradientLayer.colors = [startColor, endColor]
        case .cloud:
            let startColor = #colorLiteral(red: 0.9255903621, green: 0.9211836386, blue: 0.647629625, alpha: 1).cgColor
            let endColor = #colorLiteral(red: 0.8993768468, green: 0.8993768468, blue: 0.8993768468, alpha: 1).cgColor
            gradientLayer.colors = [startColor, endColor]
        case .fog:
            let startColor = #colorLiteral(red: 0.8465929001, green: 0.8465929001, blue: 0.8465929001, alpha: 1).cgColor
            let endColor = #colorLiteral(red: 0.7256702094, green: 0.7256702094, blue: 0.7256702094, alpha: 1).cgColor
            gradientLayer.colors = [startColor, endColor]
        default: break
            
        }
    }
    
    
    
    private func updateBackgroundImageAlpha(accordingToThe weatherType: WeatherType) {
        switch weatherType {
        case .night: backgroundLabel.alpha = 0.45
        case .rain: backgroundLabel.alpha = 0.25
        case .snow: backgroundLabel.alpha = 0.25
        case .sun: backgroundLabel.alpha = 0.25
        case .cloud: backgroundLabel.alpha = 0.17
        case .fog: backgroundLabel.alpha = 0.25
        default: break
        }
    }
    
    
    func updateUI(with weather: Weather, in city: String) {
        self.cityLabel.text = city
        self.tempLabel.text = weather.temperatureString
        self.humidityLabel.text = weather.humidityString
        self.pressureLabel.text = weather.pressureString
        self.windLabel.text = weather.windString
        self.backgroundLabel.image = UIImage(named: weather.weatherType.corespondingImageName)
        
        updateGradientLayerColor(accordingToThe: weather.weatherType)
        updateTextColor(accordingToThe: weather.weatherType)
        updateBackgroundImageAlpha(accordingToThe: weather.weatherType)
    }
    

}
