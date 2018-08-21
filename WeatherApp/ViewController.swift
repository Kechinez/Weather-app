//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 20.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    unowned var weatherView: WeatherView  {
        return self.view as! WeatherView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        //weatherView.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        weatherView.animateCancelButtonAppearing()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weatherView.animateCancelButtonDisappearing()
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        weatherView.hideCancelButton()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        
        
    }

}

