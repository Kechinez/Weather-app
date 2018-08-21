//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 20.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

let RequestedCityWasUpdatedNotificationKey = "requestedCityWasUpdated"

class ViewController: UIViewController, UITextFieldDelegate, Networking {
    
    var officialRequstedCityName: String?
    
    unowned var weatherView: WeatherView  {
        return self.view as! WeatherView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOfficialRequstedCityName(notification:)), name: NSNotification.Name(rawValue: RequestedCityWasUpdatedNotificationKey), object: nil)
        
        
    }

    @objc func updateOfficialRequstedCityName(notification: NSNotification) {
        print("official name of city is updated!")
        officialRequstedCityName = nil
        guard let tempRequestedCity = notification.userInfo?["value"] as? String else { return }
        officialRequstedCityName = tempRequestedCity
        
    }
    
    
    func startWeatherRequest() {
        let searchInput = weatherView.searchInputText!
        self.requestTranslationNameToCoordinates(with: searchInput) { (coordinates) in
            guard let notNilCoordinates = coordinates else { return }
            
            self.requestWeather(in: notNilCoordinates, completionHandler: { (weather) in
                guard let notNilWeather = weather else { return }
                print("Request is successed. \n weather is \(notNilWeather.weatherIcon), t = \(notNilWeather.temperature)")
            })
        }
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        weatherView.animateCancelButtonAppearing()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weatherView.animateCancelButtonDisappearing()
        textField.resignFirstResponder()
        
        if textField.text != "" {
            startWeatherRequest()
        }
        
        
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        weatherView.hideCancelButton()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        
        
    }

}

