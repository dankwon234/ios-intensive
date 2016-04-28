//
//  CLLoginRegisterViewController.swift
//  channel
//
//  Created by Dan Kwon on 4/20/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit

class CLLoginRegisterViewController: CLViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Profile"
        
    }
    
    override func loadView() {
        let view = self.baseView(UIColor.redColor())
        
        self.view = view

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
