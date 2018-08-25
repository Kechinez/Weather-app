//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 20.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import CoreData
let RequestedCityWasUpdatedNotificationKey = "requestedCityWasUpdated"

class WeatherViewController: UIViewController, Networking {
    
    var officialRequstedCityName: String?
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    unowned var weatherView: WeatherView  {
        return self.view as! WeatherView
    }
    
    
    
    //MARK: - Controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherView.gradientLayer = CAGradientLayer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOfficialRequstedCityName(notification:)), name: NSNotification.Name(rawValue: RequestedCityWasUpdatedNotificationKey), object: nil)
    }

    
    
    override func viewDidLayoutSubviews() {
        guard let heightOfNavBar = self.navigationController?.navigationBar.frame.height else { return }
        let height = self.view!.frame.height - heightOfNavBar
        weatherView.gradientLayer.frame = CGRect(x: 0, y: heightOfNavBar, width: self.view!.frame.width, height: height)
    
        self.view!.layer.insertSublayer(weatherView.gradientLayer, at: 0)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        weatherView.hideCancelButton()
    }
    
    
    
    
    
    //MARK: - Getting weather from API
    
    func startWeatherRequest() {
        let searchInput = weatherView.searchInputText!
        self.requestTranslationNameToCoordinates(with: searchInput) { (coordinates) in
            guard let notNilCoordinates = coordinates else { return }
            
            self.requestWeather(in: notNilCoordinates, completionHandler: { [weak self] (weather) in
                guard let notNilWeather = weather else { return }
                guard let notNilOfficialRequestedCityName = self?.officialRequstedCityName else { return }
                self?.weatherView.updateUI(with: notNilWeather, in: notNilOfficialRequestedCityName)
                self?.saveFetchedWeather(weather: notNilWeather)
            })
        }
    }
    
  
    
    func saveFetchedWeather(weather: Weather) {
        
        container?.performBackgroundTask({ [weak self] (context) in
            guard let cityName = self?.officialRequstedCityName else { return }
            SavedWeather.saveWeather(with: weather, for: cityName, in: context)
            
        })
    }
    
    
    
    
    
    // MARK: - Additional methods

    @objc func updateOfficialRequstedCityName(notification: NSNotification) {
        officialRequstedCityName = nil
        guard let tempRequestedCity = notification.userInfo?["value"] as? String else { return }
        officialRequstedCityName = tempRequestedCity
    }
    
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        weatherView.animateCancelButtonDisappearing()
    }

}





//MARK: - TextField delegate methods
extension WeatherViewController: UITextFieldDelegate {
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

}
