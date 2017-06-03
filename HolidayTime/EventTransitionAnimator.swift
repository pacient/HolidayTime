//
//  EventTransitionAnimator.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class EventTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval = 1.5
    var operation: UINavigationControllerOperation = .push
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let presenting = operation == .push
        
        // Determine which is the master view and which is the detail view that we're navigating to and from. The container view will house the views for transition animation.
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) else {return}
        guard let fromVC = transitionContext.viewController(forKey: .from) else {return }
        let storyFeedView = presenting ? fromView : toView
        let storyDetailView = presenting ? toView : fromView
        let eventsListVC = (presenting ? fromVC : toVC) as? EventTableViewController
        
        // Set the initial state of the alpha for the master and detail views so that we can fade them in and out during the animation.
        storyDetailView.alpha = presenting ? 0 : 1
        storyFeedView.alpha = presenting ? 1 : 0
        
        // Add the view that we're transitioning to to the container view that houses the animation.
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: storyDetailView)
        
        // Animate the transition.
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: .calculationModeCubic, animations: {
            if presenting {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: {
                    eventsListVC?.tableview.visibleCells.forEach({ (cell) in
                        if !cell.isSelected {
                            cell.isHidden = true
                        }
                    })
                })
                
                if self.indexPath.row != 0 {
                    UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.5, animations: {
                        eventsListVC?.events.insert(eventsListVC!.events.remove(at: self.indexPath.row), at: 0)
                        eventsListVC?.tableview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                        eventsListVC?.tableview.moveRow(at: self.indexPath, to: IndexPath(row: 0, section: 0))
                    })
                }
                
                let relativeStartTime = self.indexPath.row == 0 ? 0.0 : 0.99
                
                UIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: 0.4, animations: {
                    storyFeedView.alpha = 0
                    storyDetailView.alpha = 1
                })
            }else {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.15, animations: {
                    storyFeedView.alpha = 1
                    storyDetailView.alpha = 0
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.1, animations: {
                    eventsListVC?.tableview.visibleCells.forEach {$0.isHidden = false}
                })
                
                if self.indexPath.row != 0 {
                    UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 0.7, animations: {
                        eventsListVC?.events.insert(eventsListVC!.events.remove(at: 0), at: self.indexPath.row)
                        eventsListVC?.tableview.moveRow(at: IndexPath(row: 0, section: 0), to: self.indexPath)
                    })
                }
            }
        }, completion: { (finished) in
            eventsListVC?.isAnimating = false
            transitionContext.completeTransition(finished)
        })
    }

}
