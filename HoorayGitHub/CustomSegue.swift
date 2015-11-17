//
//  CustomSegue.swift
//  HoorayGitHub
//
//  Created by Francisco Ragland Jr on 11/16/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let sourceVC = self.sourceViewController
        let destinationVC = self.destinationViewController
        
        // add destination vc to source vc as subview
        sourceVC.view.addSubview(destinationViewController.view)
        
        // make small
        destinationVC.view.transform = CGAffineTransformMakeScale(0.05, 0.05)
        
        // perform animation
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            destinationVC.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            
            }) { (finished) -> Void in
                
                destinationVC.view.removeFromSuperview()
                
                //produces delay so destinationVC isnt push to and pulled from at the same time
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.001 * Double(NSEC_PER_SEC)))
                
                
                dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                    
                    sourceVC.presentViewController(destinationVC, animated: false, completion: nil)
                })
        }
    }

}
