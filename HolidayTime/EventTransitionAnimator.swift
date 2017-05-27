//
//  EventTransitionAnimator.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class EventTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval = 0.5
    var operation: UINavigationControllerOperation = .push
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let presenting = operation == .push
        
        // Determine which is the master view and which is the detail view that we're navigating to and from. The container view will house the views for transition animation.
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        let storyFeedView = presenting ? fromView : toView
        let storyDetailView = presenting ? toView : fromView
        
        // Set the initial state of the alpha for the master and detail views so that we can fade them in and out during the animation.
        storyDetailView.alpha = presenting ? 0 : 1
        storyFeedView.alpha = presenting ? 1 : 0
        
        // Add the view that we're transitioning to to the container view that houses the animation.
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: storyDetailView)
        
        // Animate the transition.
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            // Fade the master and detail views in and out.
            storyDetailView.alpha = presenting ? 1 : 0
            storyFeedView.alpha = presenting ? 0 : 1
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }

}
