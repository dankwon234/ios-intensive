//
//  ViewController.swift
//  first-views
//
//  Created by Dan Kwon on 4/4/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var homeButton: UIButton!
    
    @IBAction func buttonTapped(){
        print("buttonTapped")
        
        self.nameLabel.text = self.nameField.text
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameField.backgroundColor = UIColor.orangeColor()
        self.nameField.textColor = UIColor.brownColor()
        self.nameField.keyboardType = .PhonePad
//        self.nameField.becomeFirstResponder()
        
        self.homeButton.setTitle("Tap Me!", forState: .Normal)
        self.homeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        self.nameLabel.layer.borderColor = UIColor.redColor().CGColor
        self.nameLabel.layer.borderWidth = 1
        self.nameLabel.backgroundColor = UIColor.whiteColor()
        self.nameLabel.alpha = 0.25

        
        self.homeButton.layer.borderColor = UIColor.redColor().CGColor
        self.homeButton.layer.borderWidth = 1

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

