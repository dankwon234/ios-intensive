//
//  DKForumViewController.swift
//  more-views
//
//  Created by Dan Kwon on 4/5/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit

class DKForumViewController: UIViewController, UITextFieldDelegate {
    
    var commentField: UITextField!
    var comments = Array<String>()
    
    override func loadView() {
        self.edgesForExtendedLayout = .None
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.greenColor()
        
        self.commentField = UITextField(frame: CGRect(x: 20, y: 20, width: frame.size.width-40, height: 32))
        self.commentField.delegate = self
        self.commentField.autocorrectionType = .No
        self.commentField.placeholder = "Enter Comment"
        self.commentField.backgroundColor = UIColor.whiteColor()
        self.commentField.borderStyle = .RoundedRect
        view.addSubview(self.commentField)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() // makes keyboard go away
        
        let comment = self.commentField.text
        self.comments.append(comment!)
        print("\(self.comments)")
        self.commentField.text = ""
        
        return true
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
