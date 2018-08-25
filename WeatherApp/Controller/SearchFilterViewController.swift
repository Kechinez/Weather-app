//
//  SearchFilterViewController.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 22.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class SearchFilterViewController: UIViewController {
    
    @IBOutlet var keywordButtonsCollection: [UIButton]!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var cityNameTextField: UITextField!
    
    var datePicker: UIDatePicker?
    var addedKeywords: [String: Int] = [:]
    
    var startDate: Date? {
        didSet(newValue) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            startDateTextField.text = dateFormatter.string(from: startDate!)
        }
    }
    var endDate: Date? {
        didSet(newValue) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            endDateTextField.text = dateFormatter.string(from: endDate!)
        }
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
        
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueBackToSearchController"{
            if let destViewController = segue.destination as? SearchViewController {
                guard let searchFilter = SearchFilter(cityKeyword: cityNameTextField.text, addedKeywords: addedKeywords, startDate: startDate, endDate: endDate) else { return }
                destViewController.searchFilter = searchFilter
            }
        }
    }
    
    
    
    
    
    //MARK: - DatePicker methods
    
    @IBAction func keywordWasSelectedAction(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        if addedKeywords[buttonTitle] == nil {
            addedKeywords[buttonTitle] = sender.tag
            sender.tintColor = UIColor.darkGray
        } else {
            addedKeywords.removeValue(forKey: buttonTitle)
            sender.tintColor = UIColor.blue
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
    
    
}





//MARK: - TextField delegate methods
extension SearchFilterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
