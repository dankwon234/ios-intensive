//
//  CLChannel.swift
//  channel
//
//  Created by Dan Kwon on 4/15/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit
import MapKit

class CLChannel: NSObject, MKAnnotation {

    //  ["city": new york, "address": 211 east 31st street, "state": ny, "password": 1234567, "id": 571c4e08f297b003002fc62d, "name": Apartment]
    
    var address: String!
    var city: String!
    var state: String!
    var founder: String!
    var id: String!
    var name: String!
    var password: String!
    var location: CLLocation!
    
    func populate(info: Dictionary<String, AnyObject>){
        if let _address = info["address"] as? String {
            self.address = _address
        }
        
        if let _city = info["city"] as? String {
            self.city = _city
        }
        
        if let _state = info["state"] as? String {
            self.state = _state
        }
        
        if let _founder = info["founder"] as? String {
            self.founder = _founder
        }
        
        if let _id = info["id"] as? String {
            self.id = _id
        }
        
        if let _name = info["name"] as? String {
            self.name = _name
        }

        if let _password = info["password"] as? String {
            self.password = _password
        }
        
        if let _geo = info["geo"] as? Array<Double> {
//            print("GEO: \(_geo)")
            self.location = CLLocation(latitude: _geo[0], longitude: _geo[1])
            
        }
    }
    
    func dictionaryRepresentation() -> Dictionary<String, AnyObject> {
        var dict = Dictionary<String, AnyObject>()
        for key in ["id", "name", "address", "city", "state", "password"] {
            dict[key] = self.valueForKey(key)
        }
        
        return dict
    }
   
    
    // MARK: - required protocol methods for MKAnnotation:
    var title: String? { // gets displayed on the pin
        return self.name
    }
    
    var subtitle: String? { // gets displayed on the pin
        return self.address
    }
    
    var coordinate: CLLocationCoordinate2D  {
        return self.location!.coordinate
    }
    

}
