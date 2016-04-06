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
    var teamImage: UIImageView!
    var selectedTeam: String!
    
    override func loadView() {
        self.edgesForExtendedLayout = .None
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.whiteColor()
        
        self.commentField = UITextField(frame: CGRect(x: 20, y: 20, width: frame.size.width-40, height: 32))
        self.commentField.delegate = self
        self.commentField.autocorrectionType = .No
        self.commentField.placeholder = "Enter Comment"
        self.commentField.backgroundColor = UIColor.whiteColor()
        self.commentField.borderStyle = .RoundedRect
        view.addSubview(self.commentField)
        
        let y = self.commentField.frame.origin.y+self.commentField.frame.size.height+20
        self.teamImage = UIImageView(frame: CGRect(x: 0, y: y, width: 200, height: 200))
        self.teamImage.alpha = 0.5
        self.teamImage.center = CGPoint(x: 0.5*frame.size.width, y: self.teamImage.center.y)
        self.teamImage.backgroundColor = UIColor.blueColor()
        
        if (self.selectedTeam == "Mets"){
            self.teamImage.image = UIImage(named: "mets.png")
            
        }
        if (self.selectedTeam == "Yankees"){
            self.teamImage.image = UIImage(named: "yankees.png")
            
        }
        if (self.selectedTeam == "Red Sox"){
            self.teamImage.image = UIImage(named: "redsox.png")
        }
        
        
        view.addSubview(self.teamImage)
            
        
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
