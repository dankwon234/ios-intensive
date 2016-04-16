//
//  IGItem.swift
//  instagram-api
//
//  Created by Dan Kwon on 4/14/16.
//  Copyright © 2016 fullstack360. All rights reserved.


import UIKit
import Alamofire

class IGItem: NSObject {
    
    var caption: String!
    var imageUrl: String!
    var image: UIImage?
    var timestamp: NSDate?
    var formattedDate: String?
    var isFetching = false
    var comments: Array<Dictionary<String, AnyObject>>!
    
    func fetchImage(){
        if (self.isFetching == true){ // currently fetching, ignore
            return
        }
        
//        print("FETCH IMAGE")
        self.isFetching = true
        Alamofire.request(.GET, self.imageUrl, parameters: nil).response { (request, response, data, error) in
            self.isFetching = false
            
            if (data != nil){
                self.image = UIImage(data: data!)
            }
            
            
        }
    }
    
    func populate(itemInfo: Dictionary<String, AnyObject>){
        
//        print("POPULATE: \(itemInfo)")
//        print("- - - - - - - - - - - - - - - - - - - - - - - - ")
        

//        let created_time = itemInfo["created_time"]
//        print("CREATED TIME: \(created_time), \(created_time?.classForCoder)")

        if let created_time = itemInfo["created_time"] as? String {
            let ts = Double(created_time)
            self.timestamp = NSDate(timeIntervalSince1970: ts!)
            print("CREATED TIME: \(self.timestamp)")
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            let formattedDate = formatter.stringFromDate(self.timestamp!)
            print("Formatted DATE: \(formattedDate)")
            self.formattedDate = formattedDate
            
//            self.formattedDate = formatter.stringFromDate(self.timestamp!)
//            

        }
        
        if let captionInfo = itemInfo["caption"] as? Dictionary<String, AnyObject>{
            if let text = captionInfo["text"] as? String {
                self.caption = text
            }
        }

        if let commentInfo = itemInfo["comments"] as? Dictionary<String, AnyObject>{
            if let data = commentInfo["data"] as? Array<Dictionary<String, AnyObject>> {
                self.comments = data
            }
        }

        if let imageInfo = itemInfo["images"] as? Dictionary<String, AnyObject> {
            if let standard_resolution = imageInfo["standard_resolution"] as? Dictionary<String, AnyObject> {
                if let url = standard_resolution["url"] as? String {
                    self.imageUrl = url
//                    print("IMAGE URL == \(self.imageUrl)")
                    
                }
            }
        }

        
    }

}
