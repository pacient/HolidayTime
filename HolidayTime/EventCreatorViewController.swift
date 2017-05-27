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

    let countries = PickerDataResources.instance().allCountries()
    var dates = [["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                  [String](),
                  [String](),
                 ]
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
        
        //setup our pickerviews dates
        for i in 1...30 {
            let extra = i < 10 ? "0" : ""
            dates[1].append("\(extra)\(i)")
        }
        
        let date = Date()
        let year = Calendar.current.component(.year, from: date)
        for i in 0...10 {
            dates[2].append("\(year+i)")
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
    @IBAction func donePressed(_ sender: Any) {
        //TODO: Guard every textfield is filled up
        guard nameTextField.text != "" else {return}
        guard cityTextField.text != "" else {return}
        guard countryTextField.text != "" else {return}
        guard dateTextField.text != "" else {return}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.date(from: dateTextField.text!)
        if date == nil {
            //handle wrong date entered here
            return
        }
        
        let eventDict: [String : Any] = ["name" : nameTextField.text!,
                         "city" : cityTextField.text!,
                         "country" : countryTextField.text!,
                         "date" : date!]
        
        let event = Event(data: eventDict as [String : AnyObject])
        EventResourceManager.instance().add(event: event)
        navigationController?.popViewController(animated: true)
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
        }else {
            let month = dates[0][pickerView.selectedRow(inComponent: 0)]
            let day = dates[1][pickerView.selectedRow(inComponent: 1)]
            let year = dates[2][pickerView.selectedRow(inComponent: 2)]
            dateTextField.text = "\(month) \(day), \(year)"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
