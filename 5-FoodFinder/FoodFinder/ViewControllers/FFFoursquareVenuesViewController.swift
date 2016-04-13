//
//  FFFoursquareVenuesViewController.swift
//  FoodFinder
//
//  Created by Dan Kwon on 4/12/16.
//  Copyright © 2016 fullstack360. All rights reserved.


import UIKit
import CoreLocation
import Alamofire

class FFFoursquareVenuesViewController: FFViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

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
//            print("Authorized When In Use!")
            self.locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        print("didUpdateLocations: \(locations)")
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
        
        let url = "https://api.foursquare.com/v2/venues/search?v=20140806&ll=\(latLng)&client_id=VZZ1EUDOT0JYITGFDKVVMCLYHB3NURAYK3OHB5SK5N453NFD&client_secret=UAA15MIFIWVKZQRH22KPSYVWREIF2EMMH0GQ0ZKIQZC322NZ"
        
        //https://api.foursquare.com/v2/venues/search?v=20140806&ll=40.7416838,-73.9897695&client_id=VZZ1EUDOT0JYITGFDKVVMCLYHB3NURAYK3OHB5SK5N453NFD&client_secret=UAA15MIFIWVKZQRH22KPSYVWREIF2EMMH0GQ0ZKIQZC322NZ
        
        
//        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latLng)&radius=500&types=food&key=AIzaSyAeser88W3M1xByLny2F3RJCu8cMuLViUs"
        
        Alamofire.request(.GET, url, parameters: nil).responseJSON { response in
            if let JSON = response.result.value as? Dictionary<String, AnyObject> {
//                print("\(JSON)")
                if let resp = JSON["response"] as? Dictionary<String, AnyObject> {
//                    print("\(resp)")
                    
                    if let venues = resp["venues"] as? Array<Dictionary<String, AnyObject>>{
//                        print("\(venues)")
                        
                        for venueInfo in venues {
                            print("VENUE: - - - - - - - - - - - - - - \(venueInfo)")
                            let venue = FFVenue()
                            venue.populate(venueInfo)
                            self.venuesArray.append(venue)
                        }
                        
                        self.venuesTable.reloadData()
                        
                    }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let venue = self.venuesArray[indexPath.row]
        print("\(venue.name), \(venue.lat), \(venue.lng)")
        
        let mapVc = FFMapViewController()
        mapVc.venue = venue
        mapVc.allVenues = self.venuesArray
        self.navigationController?.pushViewController(mapVc, animated: true)
    }
    
    func configureCell(cell: UITableViewCell, indexPath:NSIndexPath) -> UITableViewCell{
        let venue = self.venuesArray[indexPath.row]
        
        cell.textLabel?.text = venue.name
        var details = ""
        
        if (venue.address.characters.count>0 && venue.phone.characters.count>0){
            details = "\(venue.address), \(venue.phone)"
        }
        else {
            details = "\(venue.address)\(venue.phone)"
        }

        cell.detailTextLabel?.text = details
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
