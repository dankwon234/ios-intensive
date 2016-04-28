//
//  CLChannelsMapViewController.swift
//  channel
//
//  Created by Dan Kwon on 4/20/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CLChannelsMapViewController: CLViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var currentLocation: CLLocation!
    var locationManager: CLLocationManager!
    var channelsArray = Array<CLChannel>()
    var isFetching = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Nearby"
        self.registerForNotifictions()
    }

    func registerForNotifictions(){
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
                                       selector: #selector(CLChannelsViewController.channelCreated(_:)),
                                       name: Constants.kChannelCreatedNotification,
                                       object: nil)
    }
    

    override func loadView() {
        let view = self.baseView(UIColor.blueColor())
        let frame = UIScreen.mainScreen().bounds
        
        self.mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.mapView.delegate = self
        view.addSubview(self.mapView)

        self.view = view
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add,
                                                                 target: self,
                                                                 action: #selector(CLChannelsViewController.createChannel(_:)))

        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func createChannel(btn: UIBarButtonItem){
        print("createChannel")
        let createChannelVc = CLCreateChannelViewController()
        createChannelVc.step = 0
        createChannelVc.channel = CLChannel()
        createChannelVc.loc = self.currentLocation
        let navCtr = UINavigationController(rootViewController: createChannelVc)
        navCtr.navigationBarHidden = true
        self.presentViewController(navCtr, animated: true, completion: {
            
        })
    }

    // notification callback
    func channelCreated(notification: NSNotification){
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject> {
            if let channel = userInfo["channel"] as? CLChannel {
                
                print("channelCreated: \(channel.dictionaryRepresentation().description)")
                self.channelsArray.append(channel)
                
//                print("TEST 3")
//                self.mapView.addAnnotation(channel)
//                print("TEST 4")
            }
        }
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
        
        self.currentLocation = loc
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        
        let km = CLLocationDistance(1000)
        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(loc.coordinate, 2*km, 2*km), animated: true)

        let params = ["lat":"\(loc.coordinate.latitude)", "lng":"\(loc.coordinate.longitude)"]
        self.fetchChannels(params)
    }
    
    func fetchChannels(params: Dictionary<String, AnyObject>){
        if (self.isFetching == true){
            return
        }
        
        print("fetchChannels")
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
                
                dispatch_async(dispatch_get_main_queue(), {
                    for channelInfo in results {
                        let channel = CLChannel()
                        channel.populate(channelInfo)
                        self.channelsArray.append(channel)
                    }
                    
                    self.mapView.addAnnotations(self.channelsArray)
                })
            }
        })
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? CLChannel {
            let identifier = "pin"
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
                dequeuedView.annotation = annotation
                return dequeuedView
            }
            
            
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView.canShowCallout = true
            let accessoryBtn = UIButton(type: .InfoDark)
            accessoryBtn.tag = self.channelsArray.indexOf(annotation)!
            annotationView.rightCalloutAccessoryView = accessoryBtn
//            annotationView.animatesDrop = true // only works for MKPinAnnotationView
            annotationView.image = UIImage(named: "pin.png")
            return annotationView
            
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("didSelectAnnotationView: ")
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let channel = self.channelsArray[control.tag]
//        print("calloutAccessoryControlTapped: \(channel.name)")

        let channelVc = CLChannelViewController()
        channelVc.channel = channel
        self.navigationController?.pushViewController(channelVc, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
