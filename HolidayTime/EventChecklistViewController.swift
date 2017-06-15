
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
    
    var event: Event!
    var tasks: [ChecklistTask] {
        get {
            return event.tasks
        }
        set {
            event.tasks = newValue
        }
    }
    
    var todoTasks: [ChecklistTask] {
       return tasks.reversed().filter{$0.status == .todo}
    }
    var doneTasks: [ChecklistTask] {
        return tasks.reversed().filter{$0.status == .done}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.setBackgroundImage(#imageLiteral(resourceName: "transparent"), for: .default)
        navBar.shadowImage = #imageLiteral(resourceName: "transparent")
        taskTextField.attributedPlaceholder = NSAttributedString(string: "Enter Text Here", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        taskTextField.delegate = self
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindChecklist", sender: self)
    }
    
    //MARK: Table View delegate:
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !tasks.isEmpty else {return 0}
        if section == 0 {
            return todoTasks.count //return all todo tasks
        }else {
            return doneTasks.count //return all done tasks
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskCell
        switch indexPath.section {
        case 0://Todo Tasks
            cell.task = todoTasks[indexPath.row]
        case 1://Done Tasks
            cell.task = doneTasks[indexPath.row]
        default:break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = getTask(forIndexPath: indexPath)
        if let taskIndex = self.tasks.index(of: task) {
            let cell = tableView.cellForRow(at: indexPath) as! TaskCell
            switch self.tasks[taskIndex].status {
            case .done:
                self.tasks[taskIndex].status = .todo
                cell.task = self.tasks[taskIndex]
            case .todo:
                self.tasks[taskIndex].status = .done
                cell.task = self.tasks[taskIndex]
            }
            tableView.reloadSections([0,1], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            let task = self.getTask(forIndexPath: indexPath)
            if let taskIndex = self.tasks.index(of: task) {
                self.tasks.remove(at: taskIndex)
                self.tableview.deleteRows(at: [index], with: .left)
            }
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
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
        let indexPath = IndexPath(row: 0, section: 0)
        tableview.insertRows(at: [indexPath], with: .top)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        taskTextField.resignFirstResponder()
    }
    
    //MARK: Useful functions
    fileprivate func getTask(forIndexPath indexpath: IndexPath) -> ChecklistTask {
        if indexpath.section == 0 {
            return self.todoTasks[indexpath.row]
        }else {
            return self.doneTasks[indexpath.row]
        }
    }
}
