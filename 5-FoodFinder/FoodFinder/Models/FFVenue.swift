//
//  FFVenue.swift
//  FoodFinder
//
//  Created by Dan Kwon on 4/12/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit
import MapKit

class FFVenue: NSObject, MKAnnotation {

    var name: String!
    var rating: Double!
    var lat: Double!
    var lng: Double!
    var address = ""
    var phone = ""
    
    // MARK: - required protocol methods for MKAnnotation:
    var title: String? { // gets displayed on the pin
        return self.name
    }
    
    var subtitle: String? { // gets displayed on the pin
        return self.address
    }
    
    var coordinate: CLLocationCoordinate2D  {
        return CLLocationCoordinate2DMake(self.lat, self.lng)
    }
    
    func populate(info: Dictionary<String, AnyObject>){

        if let n = info["name"] as? String {
            self.name = n
        }

        if let a = info["vicinity"] as? String {
            self.address = a
        }

        if let location = info["location"] as? Dictionary<String, AnyObject> {
            print("LOCATION: \(location)")
            if let addr = location["address"] as? String {
                self.address = addr
            }

            if let latitude = location["lat"] as? Double {
                self.lat = latitude
            }

            if let longitude = location["lng"] as? Double {
                self.lng = longitude
            }

        }
        
        if let r = info["rating"] as? Double {
            self.rating = r
        }

        if let contact = info["contact"] as? Dictionary<String, AnyObject> {
            if let formattedPhone = contact["formattedPhone"] as? String {
                self.phone = formattedPhone
            }
        }

        
//        , "contact": {
//            formattedPhone = "(212) 391-0107";
//            phone = 2123910107;
//        }, "name": Jacqueline Kennedy Onassis High School]
    }
    
    
}
