//
//  EventTableViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class EventTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var tableview: UITableView!
    var events = EventResourceManager.instance().allEvents()
    let transitionAnimator = EventTransitionAnimator()
    var isAnimating = false
    var selectedIndexPath: IndexPath?
    var animateLeft = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        events = EventResourceManager.instance().allEvents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadEvents), name: Notf.updateEvents, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        if let selectedIndex = self.tableview.indexPathForSelectedRow {
            self.tableview.deselectRow(at: selectedIndex, animated: false)
        }
        self.selectedIndexPath = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        events = EventResourceManager.instance().allEvents()
        self.tableview.reloadData()
    }
    
    func reloadEvents() {
        events = EventResourceManager.instance().allEvents()
        self.tableview.reloadData()
    }
    
    //TODO: This are to go to a view model for the event
    func getRemainingDays(forDate: Date) -> String {
        let calendar = Calendar.current
        
        let today = calendar.date(bySettingHour: 12, minute: 00, second: 00, of: Date())!
        
        let components = calendar.dateComponents([.day], from: today, to: forDate)
        return "\(components.day ?? 0)"
    }
    
    func colourFor(row: Int) -> UIColor {
        if row % 3 == 0 { return UIColor.CustomColors.blueCell }
        if row % 2 == 0 { return UIColor.CustomColors.greenCell }
        return UIColor.CustomColors.brownCell
    }
    
    //Button Actions
    @IBAction func addEventPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "EventCreator", bundle: nil).instantiateInitialViewController() as! EventCreatorViewController
        vc.viewTitle = "Create Event"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Nav Controller Delegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (toVC.isKind(of: EventDetailViewController.self) || toVC.isKind(of: EventTableViewController.self)) && (fromVC.isKind(of: EventTableViewController.self) || fromVC.isKind(of: EventDetailViewController.self)) {
            transitionAnimator.operation = operation
            transitionAnimator.indexPath = selectedIndexPath!
            animateLeft = false
            return transitionAnimator
        }
        animateLeft = true
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if selectedIndexPath == nil && viewController.isKind(of: EventCreatorViewController.self) {
            self.tableview.visibleCells.forEach{$0.isHidden = true}
        }else if selectedIndexPath == nil {
            self.tableview.visibleCells.forEach{$0.isHidden = false}
        }
    }
    
    //MARK: TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        cell.isHidden = isAnimating
        cell.eventName.text = events[indexPath.row].name
        cell.eventDays.text = getRemainingDays(forDate: events[indexPath.row].date)
        cell.eventCard.backgroundColor = colourFor(row: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if selectedIndexPath != indexPath {
            let direction: CGFloat = animateLeft ? -1 : 1
            cell.transform = CGAffineTransform(translationX: cell.bounds.size.width*direction, y: 0)
            UIView.animate(withDuration: 0.3) {
                cell.transform = .identity
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isAnimating = true
        self.selectedIndexPath = indexPath
        let eventTapped = self.events[indexPath.row]
        let vc = UIStoryboard(name: "EventDetails", bundle: nil).instantiateInitialViewController() as! EventDetailViewController
        vc.event = eventTapped
        vc.cardColour = colourFor(row: indexPath.row)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            EventResourceManager.instance().remove(event: self.events[index.row])
            self.events.removeObject(self.events[index.row])
            tableView.reloadData()
        }
        return [action]
    }
}
