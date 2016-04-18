//
//  ViewController.swift
//  beer-me
//
//  Created by Dan Kwon on 4/18/16.
//  Copyright © 2016 dankwon. All rights reserved.
//


import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "http://api.brewerydb.com/v2/beers?key=80c34b91489455cf1d9622a781680385&name=summer%20ale"
        
        Alamofire.request(.GET, url, parameters: nil).responseJSON { response in
            if let JSON = response.result.value as? Dictionary<String, AnyObject>{
                print("\(JSON)")
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

