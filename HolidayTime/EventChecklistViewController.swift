//
//  EventChecklistViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 14/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class EventChecklistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, UITextFieldDelegate {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    
    var tasks: [ChecklistTask]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.setBackgroundImage(#imageLiteral(resourceName: "transparent"), for: .default)
        navBar.shadowImage = #imageLiteral(resourceName: "transparent")
        taskTextField.attributedPlaceholder = NSAttributedString(string: "Enter Text Here", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        taskTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Table View delegate:
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.isEmpty ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !tasks.isEmpty else {return 0}
        if section == 0 {
            return tasks.filter{$0.status == .todo}.count //return all todo tasks
        }else {
            return tasks.filter{$0.status == .done}.count //return all done tasks
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskCell
        switch indexPath.section {
        case 0://Todo Tasks
            let todoTasks = tasks.filter{$0.status == .todo}
            cell.taskTitle.text = todoTasks[indexPath.row].title
        case 1://Done Tasks
            let doneTasks = tasks.filter{$0.status == .done}
            cell.taskTitle.text = doneTasks[indexPath.row].title
        default:break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Nav Bar Delegate
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    //MARK: Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.tableview.scrollsToTop = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.text != "" else {return false}
        let newTask = ChecklistTask(title: textField.text!, status: .todo)
        tasks.append(newTask)
        tableview.reloadData()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        taskTextField.resignFirstResponder()
    }
}
