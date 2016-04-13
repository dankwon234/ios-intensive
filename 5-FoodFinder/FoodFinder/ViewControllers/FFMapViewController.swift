//
//  FFMapViewController.swift
//  FoodFinder
//
//  Created by Dan Kwon on 4/13/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit
import MapKit

class FFMapViewController: FFViewController, MKMapViewDelegate {
    
    var venue: FFVenue!
    var allVenues: Array<FFVenue>!
    var mapView: MKMapView!
    
    override func loadView() {
        self.title = self.venue.name
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.grayColor()
        
        self.mapView = MKMapView(frame: frame)
        let center = CLLocationCoordinate2DMake(self.venue.lat, self.venue.lng)
        self.mapView.centerCoordinate = center
        
        
        let regionRadius: CLLocationDistance = 200
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(center, regionRadius, regionRadius)
        
        self.mapView.setRegion(coordinateRegion, animated: true)
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.addAnnotations(self.allVenues)
        
        view.addSubview(self.mapView)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        if let annotation = annotation as? FFVenue {
            let identifier = "pin"
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                dequeuedView.canShowCallout = true
                dequeuedView.animatesDrop = true
                return dequeuedView
            }
        }

        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
