//
//  EventCreatorViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class EventCreatorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private let gradientLayer = RadialGradientLayer()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var countryErrorLabel: UILabel!
    @IBOutlet weak var dateErrorLabel: UILabel!
    

    let countries = PickerDataResources.instance().allCountries()
    var dates = PickerDataResources.instance().allDates()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countryPicker = UIPickerView()
        let datePicker = UIPickerView()
        let pickers = [countryPicker, datePicker]
        for (index,each) in pickers.enumerated(){
            each.delegate = self
            each.backgroundColor = .white
            each.tag = index
        }
        
        countryTextField.inputView = countryPicker
        dateTextField.inputView = datePicker
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if gradientLayer.superlayer == nil {
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = self.view.bounds
        let textFields = [nameTextField,cityTextField,countryTextField,dateTextField]
        textFields.forEach { (field) in
            field?.layer.borderColor = UIColor.white.cgColor
            field?.layer.borderWidth = 1.0
            field?.layer.cornerRadius = 5
        }
    }
    
    //MARK: Button Actions
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        nameErrorLabel.isHidden = true
        countryErrorLabel.isHidden = true
        dateErrorLabel.isHidden = true
        //TODO: Guard every textfield is filled up
        guard nameTextField.text != "" else {
            nameErrorLabel.isHidden = false
            return
        }
        guard countryTextField.text != "" else {
            countryErrorLabel.isHidden = false
            return
        }
        guard dateTextField.text != "" else {
            dateErrorLabel.isHidden = false
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.date(from: dateTextField.text!)
        if date == nil {
            //handle wrong date entered here
            dateErrorLabel.text = "This is not a valid date"
            dateErrorLabel.isHidden = false
            return
        }else if date! < Date() {
            dateErrorLabel.text = "This is not a future date"
            dateErrorLabel.isHidden = false
            return
        }
        
        let eventDict: [String : Any] = ["name" : nameTextField.text!,
                         "city" : cityTextField.text!,
                         "country" : countryTextField.text!,
                         "date" : date!]
        
        EventResourceManager.instance().setupValues(data: eventDict)
        
        let vc = UIStoryboard(name: "EventCreator", bundle: nil).instantiateViewController(withIdentifier: "bgVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return 1
        }
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return countries.count
        }
        return dates[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return countries[row]
        }
        return dates[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            countryTextField.text = countries[row]
            countryErrorLabel.isHidden = true
        }else {
            let month = dates[0][pickerView.selectedRow(inComponent: 0)]
            let day = dates[1][pickerView.selectedRow(inComponent: 1)]
            let year = dates[2][pickerView.selectedRow(inComponent: 2)]
            dateTextField.text = "\(month) \(day), \(year)"
            dateErrorLabel.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
