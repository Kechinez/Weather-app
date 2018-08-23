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

class WeatherViewController: UIViewController, UITextFieldDelegate, Networking {
    
    var officialRequstedCityName: String?
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    unowned var weatherView: WeatherView  {
        return self.view as! WeatherView
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //weatherView.backgroundLabel.alpha = 0.2
        weatherView.gradientLayer = CAGradientLayer()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOfficialRequstedCityName(notification:)), name: NSNotification.Name(rawValue: RequestedCityWasUpdatedNotificationKey), object: nil)
        
        
        
    }

    override func viewDidLayoutSubviews() {
        guard let heightOfNavBar = self.navigationController?.navigationBar.frame.height else { return }
        let height = self.view!.frame.height - heightOfNavBar
        weatherView.gradientLayer.frame = CGRect(x: 0, y: heightOfNavBar, width: self.view!.frame.width, height: height)
    
        self.view!.layer.insertSublayer(weatherView.gradientLayer, at: 0)
    }
    
    
    @objc func updateOfficialRequstedCityName(notification: NSNotification) {
        officialRequstedCityName = nil
        guard let tempRequestedCity = notification.userInfo?["value"] as? String else { return }
        officialRequstedCityName = tempRequestedCity
        
    }
    
    
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
    
    
    

    
    
//    private func fillOutCoreDataWithData() {
//        for i in 1...3 {
//            container?.performBackgroundTask({ (context) in
//                let objectToBeSaved = SavedWeather(context: context)
//                let weather = self.weatherArrayInLondon[i - 1] as! [Any]
//                objectToBeSaved.temperature = weather[0] as! Double
//                objectToBeSaved.pressure = weather[1] as! Double
//                objectToBeSaved.humidity = weather[2] as! Double
//                objectToBeSaved.wind = weather[3] as! Double
//                objectToBeSaved.weatherKeyword = weather[4] as! String
//                objectToBeSaved.city = weather[5] as! String
//
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH:mm"
//                let d = i * 7
//
//                let str = (d > 9 ? "\(d)" : "0\(d)")
//                let stringDate = "2018-07.\(str)T\(19 + i):\(43 + i)"
//                print(stringDate)
//                let date = dateFormatter.date(from: stringDate)
//                objectToBeSaved.date = date
//
//                do {
//                    try context.save()
//                    print("Weather is saved!")
//                } catch {
//                    print(error)
//                }
//
//
//            })
//        }
//
//    }
    
    
    
    
    
    
    
    func saveFetchedWeather(weather: Weather) {
        
        container?.performBackgroundTask({ [weak self] (context) in
            guard let cityName = self?.officialRequstedCityName else { return }
            SavedWeather.saveWeather(with: weather, for: cityName, in: context)
            
        })
        
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

