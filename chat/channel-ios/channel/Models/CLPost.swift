//
//  CLPost.swift
//  channel
//
//  Created by Dan Kwon on 4/15/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit
//import Alamofire

class CLPost: NSObject {

    var timestamp: NSDate!
    var text: String!
    var from: String!
    var video: String!
    var formattedDate: String?
    var image = ""
    var imageData: UIImage?
    var isFetching = false
    
    func fetchImage(){
        if (self.image.characters.count == 0){
            return
        }
        
        if (self.isFetching == true){
            return
        }
        
        self.isFetching = true
        
        let networkManager = CLNetworkManager.sharedInstance
        networkManager.fetchImage(self.image, parameters: nil, completion: { (error, image) in
            self.isFetching = false
            if (error != nil){
                return
            }
            
            self.imageData = image
            
//            let filePath = networkManager.createFilePath(self.image)
//            networkManager.cacheImage(self.imageData!, toPath: filePath)
            
        })
        
        
//        networkManager.fetchData(url, parameters: nil, completion: { (error, data) in
//            self.isFetching = false
//            if (error != nil){
//                return
//            }
//            
//            self.imageData = UIImage(data: data!)
//            let filePath = networkManager.createFilePath(self.image)
//            networkManager.cacheImage(self.imageData!, toPath: filePath)
//        })
        
        
    }
    
    func populate(info: Dictionary<String, AnyObject>) {
//        print("POPULATE: \(info)")
        
        if let _text = info["text"] as? String {
            self.text = _text
        }

        if let _from = info["from"] as? String {
            self.from = _from
        }

        if let _image = info["image"] as? String {
            self.image = _image
        }

        if let _video = info["video"] as? String {
            self.video = _video
        }

        if let _timesatmp = info["timesatmp"] as? Double {
            self.timestamp =  NSDate(timeIntervalSince1970: _timesatmp)
//            print("TIMESTAMP: \(self.timestamp)")
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd, hh:mma yyyy" // "May 16, 1:45PM 2015"
            self.formattedDate = dateFormatter.stringFromDate(self.timestamp)
        }

    }
}




//#pragma mark - FileSavingStuff:
//- (NSString *)createFilePath:(NSString *)fileName
//{
//    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"+"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
//    return filePath;
//}
