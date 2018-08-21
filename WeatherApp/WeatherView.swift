//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 21.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    @IBOutlet weak var cancelButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextFieldConstarint: NSLayoutConstraint!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var backgroundLabel: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var searchInputText: String? {
        return (cityLabel.text != "" ? cityLabel.text! : "")
    }
    
    
    func hideCancelButton() {
        cancelButtonConstraint.constant = -30.0
    }
    
    
    
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
    }
    
    

}
