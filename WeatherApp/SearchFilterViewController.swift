//
//  SearchFilterViewController.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 22.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class SearchFilterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var keywordButtonsCollection: [UIButton]!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var cityNameTextField: UITextField!
    
    var datePicker: UIDatePicker?
    var addedKeywords: [String: Int] = [:]
    
    var startDate: Date? {
        didSet(newValue) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.dd.yyyy"
            startDateTextField.text = dateFormatter.string(from: startDate!)
        }
    }
    var endDate: Date? {
        didSet(newValue) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.dd.yyyy"
            endDateTextField.text = dateFormatter.string(from: endDate!)
        }
    }
    
    
    
    
    @IBAction func keywordWasSelectedAction(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        if addedKeywords[buttonTitle] == nil {
            addedKeywords[buttonTitle] = sender.tag
            sender.tintColor = UIColor.darkGray
            print("item added")
        } else {
            addedKeywords.removeValue(forKey: buttonTitle)
            sender.tintColor = UIColor.blue
            print("item deleted")
        }
    }
    
    
    @objc func dateChange(datePicker: UIDatePicker) {
      
        if startDateTextField.isFirstResponder {
            startDate = datePicker.date
        } else {
            endDate = datePicker.date
        }
    }
    
    
    @objc func cancelDatePicker() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelDatePicker))
        view!.addGestureRecognizer(tapGestureRecognizer)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        
        endDateTextField.inputView = datePicker
        startDateTextField.inputView = datePicker
        
        // Do any additional setup after loading the view.
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueBackToSearchController"{
            if let destViewController = segue.destination as? SearchViewController {
                guard let searchFilter = SearchFilter(cityKeyword: cityNameTextField.text, addedKeywords: addedKeywords, startDate: startDate, endDate: endDate) else { return }
                destViewController.searchFilter = searchFilter
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
