//
//  DKHomeViewController.swift
//  election
//
//  Created by Dan Kwon on 4/11/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit
import Alamofire

class DKHomeViewController: DKViewController, UITableViewDataSource, UITableViewDelegate {
    
    var candidatesTable: UITableView!
    var candidatesArray = Array<Dictionary<String, AnyObject>>()
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        
        self.candidatesTable = UITableView(frame: frame, style: .Plain)
        self.candidatesTable.dataSource = self
        self.candidatesTable.delegate = self
        self.candidatesTable.autoresizingMask = .FlexibleHeight
        view.addSubview(self.candidatesTable)
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://dk-election-2016.herokuapp.com/api/profile"
        
        Alamofire.request(.GET, url, parameters: nil).responseJSON { response in
            if let JSON = response.result.value as? Dictionary<String, AnyObject> {
                print("\(JSON)")
                
                if let profiles = JSON["profiles"] as? Array<Dictionary<String, AnyObject>>{
                    self.candidatesArray = profiles
                    self.candidatesTable.reloadData()
                    
                }
            }
            
        }
        
        
//        Alamofire.request(.GET, url, nil, function(err, response){
//            stuff!
//        });

    }

    // MARK: - Tableview Stuff:
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.candidatesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let profile = self.candidatesArray[indexPath.row]
        let details = "\(profile["party"]!), \(profile["state"]!)"
        
        let cellId = "cellID"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId) {
            cell.textLabel?.text = profile["name"] as? String
            cell.detailTextLabel?.text = details
            return cell
        }

        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = profile["name"] as? String
        cell.detailTextLabel?.text = details
//        cell.detailTextLabel?.text = profile["state"] as? String
        return cell

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
