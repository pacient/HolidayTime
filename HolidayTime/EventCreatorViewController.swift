//
//  EventCreatorViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class EventCreatorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    private let gradientLayer = RadialGradientLayer()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var countryErrorLabel: UILabel!
    @IBOutlet weak var dateErrorLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var viewTitle: String!
    var isEventEditing = false
    var event: Event?
    let countries = PickerDataResources.instance().allCountries()
    var dates = PickerDataResources.instance().allDates()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countryPicker = UIPickerView()
        countryPicker.delegate = self
        countryPicker.backgroundColor = .white
        
        countryTextField.inputView = countryPicker
        dateTextField.delegate = self
        navBar.setBackgroundImage(#imageLiteral(resourceName: "transparent"), for: .default)
        navBar.shadowImage = #imageLiteral(resourceName: "transparent")
        navBar.topItem?.title = viewTitle
        if !isEventEditing {
            navBar.topItem?.rightBarButtonItem = nil
        }
        if let event = event {
            self.nameTextField.text = event.name
            self.cityTextField.text = event.city
            self.countryTextField.text = event.country
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateText = dateFormatter.string(from: event.date)
            self.dateTextField.text = dateText
            EventResourceManager.instance().setupValues(with: event)
        }
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
    
    //MARK: Function
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let selectedDate = dateFormatter.string(from: sender.date)
        dateTextField.text = selectedDate
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            let datePick = UIDatePicker()
            datePick.date = isEventEditing ? event!.date : Date()
            datePick.datePickerMode = .date
            datePick.backgroundColor = .white
            datePick.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
            
            textField.inputView = datePick
        }
    }
    
    func verifyTextFields() -> Bool {
        nameErrorLabel.isHidden = true
        countryErrorLabel.isHidden = true
        dateErrorLabel.isHidden = true
        guard nameTextField.text != "" else {
            nameErrorLabel.isHidden = false
            return false
        }
        guard countryTextField.text != "" else {
            countryErrorLabel.isHidden = false
            return false
        }
        guard dateTextField.text != "" else {
            dateErrorLabel.isHidden = false
            return false
        }
        return true
    }
    
    func getValidDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.locale = Locale.current
        let date = dateFormatter.date(from: dateTextField.text!)
        if date == nil {
            dateErrorLabel.text = "This is not a valid date"
            dateErrorLabel.isHidden = false
            return nil
        }else if date! < Date() {
            dateErrorLabel.text = "This is not a future date"
            dateErrorLabel.isHidden = false
            return nil
        }
        return date
    }
    //MARK: Button Actions
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneBarButtonPressed(_ sender: Any) {
        guard verifyTextFields() == true else {return}
        guard let date = getValidDate() else {return}
        let tasks = event!.tasks
        let eventDict: [String : Any] = ["name" : nameTextField.text!,
                         "city" : cityTextField.text!,
                         "country" : countryTextField.text!,
                         "date" : date,
                         "tasks" : tasks,
                         "bgimage" : event!.backgroundImage]
        
        if EventResourceManager.instance().eventCity != cityTextField.text! || EventResourceManager.instance().eventCountry != countryTextField.text! {
            WeatherManager.instance().getWeather(forCity: cityTextField.text!, country: countryTextField.text!, completionHandler: { (results) in
                if let results = results {
                    EventResourceManager.instance().setupValues(data: eventDict)
                    EventResourceManager.instance().eventTemperture = results["temperture"]
                    EventResourceManager.instance().eventWeatherCode = results["code"]
                    EventResourceManager.instance().eventLastUpdatedWeather = Date()
                    EventResourceManager.instance().updateEvent()
                    NotificationCenter.default.post(name: Notf.updateView, object: nil)
                }
            })
        }
        
        EventResourceManager.instance().setupValues(data: eventDict)
        EventResourceManager.instance().updateEvent()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        guard verifyTextFields() == true else {return}
        guard let date = getValidDate() else {return}
        let tasks = event != nil ? event!.tasks : [ChecklistTask]()
        let eventDict: [String : Any] = ["name" : nameTextField.text!,
                         "city" : cityTextField.text!,
                         "country" : countryTextField.text!,
                         "date" : date,
                         "tasks" : tasks]
        
        EventResourceManager.instance().setupValues(data: eventDict)
        
        let vc = UIStoryboard(name: "EventCreator", bundle: nil).instantiateViewController(withIdentifier: "bgVC") as! BackgroundSelectorViewController
        vc.isEventEditing = self.isEventEditing
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = countries[row]
        countryErrorLabel.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
