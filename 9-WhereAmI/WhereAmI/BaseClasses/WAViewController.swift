//
//  WAViewController.swift
//  WhereAmI
//
//  Created by Dan Kwon on 4/20/16.
//  Copyright © 2016 dankwon. All rights reserved.


import UIKit

class WAViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func shiftView(position: CGFloat){
        if (self.view.frame.origin.y == position){
            return
        }
        
        UIView.animateWithDuration(0.25,
                                   delay: 0,
                                   options: .CurveEaseInOut,
                                   animations: {
                                    var frame = self.view.frame
                                    frame.origin.y = position
                                    self.view.frame = frame
                                    
            },
                                   completion: nil)
        
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
