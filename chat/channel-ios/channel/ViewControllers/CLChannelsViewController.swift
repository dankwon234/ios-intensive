//
//  CLChannelsViewController.swift
//  channel
//
//  Created by Dan Kwon on 4/15/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire


class CLChannelsViewController: CLViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var channelsTable: UITableView!
    var channelsArray = Array<CLChannel>()
    var isFetching = false
    var mode: Int!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.registerForNotifictions()
        
    }
    
    init(mode: Int) {
        super.init(nibName: nil, bundle: nil)
        self.mode = mode
        self.title = (self.mode == 0) ? "Nearby Channels" : "My Channels"
        self.registerForNotifictions()
    }
    
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.blueColor()
        
        self.channelsTable = UITableView(frame: frame, style: .Plain)
        self.channelsTable.autoresizingMask = .FlexibleHeight
        self.channelsTable.dataSource = self
        self.channelsTable.delegate = self
        view.addSubview(self.channelsTable)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (self.mode == 0){ // nearby mode
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add,
                                                                     target: self,
                                                                     action: #selector(CLChannelsViewController.createChannel(_:)))
            
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            return
        }
        
        
        self.fetchChannels(["members":"123123"])
    }
    
    func registerForNotifictions(){
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
                                       selector: #selector(CLChannelsViewController.channelCreated(_:)),
                                       name: Constants.kChannelCreatedNotification,
                                       object: nil)
    }

    
    func fetchChannels(params: Dictionary<String, AnyObject>){
        if (self.isFetching == true){
            return
        }
        
        self.isFetching = true
        let networkMgr = CLNetworkManager.sharedInstance
        let url = Constants.kBaseUrl+"/api/channel"
        networkMgr.getRequest(url, params:params, completion: { (error, response) in
            self.isFetching = false
            if (error != nil){
                print("\(error)")
                return
            }
            
            print("\(response!)")
            if let results = response?["results"] as? Array<Dictionary<String, AnyObject>> {
                for channelInfo in results {
                    let channel = CLChannel()
                    channel.populate(channelInfo)
                    self.channelsArray.append(channel)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.channelsTable.reloadData()
                })
            }
        })
    }
    
    func channelCreated(notification: NSNotification){
        print("channelCreated: \(notification)")
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject> {
            if let channel = userInfo["channel"] as? CLChannel {
                self.channelsArray.append(channel)
                self.channelsTable.reloadData()
            }
        }
    }
    
    func createChannel(btn: UIBarButtonItem){
        print("createChannel")
        let createChannelVc = CLCreateChannelViewController()
        self.presentViewController(createChannelVc, animated: true, completion: {
            
        })
    }
    
    
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channelsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let channel = self.channelsArray[indexPath.row]
        let cellId = "cellId"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId) {
            cell.textLabel?.text = channel.name
            return cell
        }
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = channel.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let channel = self.channelsArray[indexPath.row]
//        print("\(channel.name)")
        
        let channelVc = CLChannelViewController()
        channelVc.channel = channel
        self.navigationController?.pushViewController(channelVc, animated: true)
    }

    
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == .AuthorizedWhenInUse){
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("\(locations))")
        
        if (locations.count == 0){
            return
        }
        
        let loc = locations[0]
        if (loc.horizontalAccuracy > 100){
            return
        }
        
        self.locationManager.stopUpdatingLocation()
        self.currentLocation = loc
        
        let params = ["lat":"\(loc.coordinate.latitude)", "lng":"\(loc.coordinate.longitude)"]
        self.fetchChannels(params)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
