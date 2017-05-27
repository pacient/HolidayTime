//
//  EventTableViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class EventTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    var dataSource: [Int] = [1,2,3,4,5,7,8,9]
    let transitionAnimator = EventTransitionAnimator()
    var isAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
    }

    //Button Actions
    @IBAction func addEventPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "EventCreator", bundle: nil).instantiateInitialViewController()!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Nav Controller Delegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator.operation = operation
        return transitionAnimator
    }
    
    //MARK: TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        cell.isHidden = isAnimating
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isAnimating = true
        // Hide all the cells and move the selected cell to the top and then present the details controller
        tableView.visibleCells.forEach { (cell) in
            if !cell.isSelected {
                UIView.animate(withDuration: 0.5, animations: {
                    cell.isHidden = true
                })
            }
        }
        UIView.animate(withDuration: 1, animations: {
            tableView.beginUpdates()
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            self.dataSource.insert(self.dataSource.remove(at: indexPath.row), at: 0)
            tableView.endUpdates()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }) { (finished) in
            if finished {
                self.isAnimating = false
                let vc = UIStoryboard(name: "EventDetails", bundle: nil).instantiateInitialViewController()!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
