//
//  FFHomeViewController.swift
//  FoodFinder
//
//  Created by Dan Kwon on 4/12/16.
//  Copyright © 2016 fullstack360. All rights reserved.


import UIKit
import CoreLocation
import Alamofire

class FFVenuesViewController: FFViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var venuesTable: UITableView!
    var locationManager: CLLocationManager!
    var venuesArray = Array<FFVenue>()
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.grayColor()
        
        self.venuesTable = UITableView(frame: frame, style: .Plain)
        self.venuesTable.dataSource = self
        self.venuesTable.delegate = self
        self.venuesTable.separatorStyle = .None
        view.addSubview(self.venuesTable)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    
    // MARK: - LocationManager Delegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        
        if (status == .AuthorizedWhenInUse){ // user said ' YES '
            print("Authorized When In Use!")
            self.locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("didUpdateLocations: \(locations)")
        if (locations.count == 0){
            return
        }
        
        let loc = locations[0]
        let now = NSDate().timeIntervalSince1970
        let locationTime = loc.timestamp.timeIntervalSince1970
        let delta = now-locationTime
        
        if (delta > 10){ // cached data, ignore
            return
        }
        
        if (loc.horizontalAccuracy > 100){ // not accurate enough
            return
        }
        
        self.locationManager.stopUpdatingLocation()
//        print("Found Current Location: \(loc.description)")
        
        let latLng = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latLng)&radius=500&types=food&key=AIzaSyAeser88W3M1xByLny2F3RJCu8cMuLViUs"
        
        Alamofire.request(.GET, url, parameters: nil).responseJSON { response in
            if let JSON = response.result.value as? Dictionary<String, AnyObject> {
                //                print("\(JSON)")
                
                if let results = JSON["results"] as? Array<Dictionary<String, AnyObject>>{
                    for venueInfo in results {
                        // eventually more logic will be here...
                        let venue = FFVenue()
                        venue.populate(venueInfo)
                        self.venuesArray.append(venue)
                    }
                    
                    self.venuesTable.reloadData()
                    
                }
            }
        }
    }
    
    // MARK: - Tableview Stuff
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venuesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "cellId"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId){
            return self.configureCell(cell, indexPath: indexPath)
        }
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        return self.configureCell(cell, indexPath: indexPath)
    }
    
    func configureCell(cell: UITableViewCell, indexPath:NSIndexPath) -> UITableViewCell{
        let venue = self.venuesArray[indexPath.row]
        
        cell.textLabel?.text = venue.name
        cell.detailTextLabel?.text = "\(venue.address), \(venue.rating) stars"
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
