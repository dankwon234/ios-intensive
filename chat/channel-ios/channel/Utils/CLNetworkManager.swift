//
//  CLNetworkManager.swift
//  channel
//
//  Created by Dan Kwon on 4/8/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation


class CLNetworkManager: NSObject {
    
    static let sharedInstance = CLNetworkManager()
    
    
    // MARK: - General Requests
    func getRequest(url:String, params:Dictionary<String, AnyObject>?, completion:((NSError?, Dictionary<String, AnyObject>?) -> Void)?){
        Alamofire.request(.GET, url, parameters: params).responseJSON { response in
            if let JSON = response.result.value as? Dictionary<String, AnyObject> {
//                print("\(JSON)")
                
                if (completion != nil){
                    completion?(nil, JSON)
                }
                
            }
        }
    }
    
    func postRequest(url:String, params: Dictionary<String, AnyObject>?, completion:((NSError?, Dictionary<String,AnyObject>?) -> Void)?){
        Alamofire.request(.POST, url, parameters: params).responseJSON { response in
            
            if let JSON = response.result.value as? Dictionary<String, AnyObject> {
                if (completion != nil){
                    
                    completion?(nil, JSON);
                    
                }
            }
        }
    }
    
    
//    func createChannel(params:Dictionary<String, AnyObject>, completion: ((NSError?, Dictionary<String, AnyObject>) -> Void)?){
//        
//        let url = Constants.kBaseUrl+"/api/channel"
//        Alamofire.request(.POST, url, parameters: params).responseJSON { response in
//            
//            if let JSON = response.result.value as? Dictionary<String, AnyObject> {
//                if (completion != nil){
//                    
//                    completion?(nil, JSON);
//                    
//                }
//            }
//        }
//    }
    
    func fetchData(url: String, parameters:Dictionary<String, AnyObject>?, completion:((NSError?, NSData?) -> Void)?){
        Alamofire.request(.GET, url, parameters: parameters).response { (request, response, data, error) in
            if (error != nil){
                if (completion != nil){
                    completion?(error, nil)
                }
                return
            }
            
            if (completion != nil){
                completion?(nil, data)
            }

        }
    }
    
    func fetchImage(imageId:String, parameters:Dictionary<String, AnyObject>?, completion:((NSError?, UIImage?) -> Void)?){
        
//        check cache first:
        let filePath =  self.createFilePath(imageId)
        if let data = NSData(contentsOfFile: filePath) {
            let image = UIImage(data: data)
            print("CACHED IMAGE: \(imageId), \(data.length) bytes")
            
            if (completion != nil){
                completion?(nil, image);
                
            }

            return
        }
        
        
        let url = "https://media-service.appspot.com/site/images/"+imageId+"?crop=64"
        Alamofire.request(.GET, url, parameters: parameters).response { (request, response, data, error) in
            if (error != nil){
                if (completion != nil){
                    completion?(error, nil)
                }
                return
            }
            
            if let image = UIImage(data: data!){
                let filePath = self.createFilePath(imageId)
                self.cacheImage(image, toPath: filePath)
                
                
                if (completion != nil){
                    completion?(nil, image)
                }
                
                return
            }
            
            // TODO: HANDLE ERROR
            
        }
    }

    
    func uplaodImageData(requestURL: String, postData:[String:AnyObject], completion:((NSError?, Dictionary<String, AnyObject>?) -> Void)?) -> () {
        let imgData = postData["data"] as? NSData
        let name = postData["name"] as! String
        
        Alamofire.upload(.POST, requestURL,
                         multipartFormData: { multipartFormData in
                            multipartFormData.appendBodyPart(data: imgData!, name: "file", fileName: name, mimeType: "image/jpeg")
            },
                         encodingCompletion: { encodingResult in
                            print("Completion: \(encodingResult)")
                            switch encodingResult {
                            case .Success(let upload, _, _):
                                upload.responseJSON { response in
                                    print("UPLOAD RESPONSE: \(response)")
                                    if let JSON = response.result.value as? Dictionary<String, AnyObject>{
                                        print("UPLOAD DONE: \(JSON)")
                                        if let imageInfo = JSON["image"] as? Dictionary<String, AnyObject> {
                                            if (completion != nil){
                                                completion?(nil, imageInfo)
                                            }
                                            
                                        }
                                        
                                    }
                                }
                                
                            case .Failure(let encodingError):
                                print("UPLOAD FAIL \(encodingError): ")
                                if (completion != nil){
                                    let error = NSError(domain: "com.fs-channel", code: 0, userInfo: ["message":"error"])
                                    completion?(error, nil)
                                }
                            }
            }
        )
    }
    
    
    
    func cacheImage(image:UIImage, toPath: String){
        let imgData = UIImageJPEGRepresentation(image, 1.0)
        do {
            try imgData?.writeToFile(toPath, options: .DataWritingAtomic)
            
        }
        catch {
            
        }
        
    }
    
    func createFilePath(fileName: String) -> String{
        let updatedFileName = fileName.stringByReplacingOccurrencesOfString("/", withString: "+")
        var paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let p = paths[0]
        let path = p+"/"+updatedFileName
        print("FILEPATH == \(path)")
        return path
        
    }
    

    
//    - (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
//    {
//    const char* filePath = [[URL path] fileSystemRepresentation];
//    const char* attrName = "com.apple.MobileBackup";
//    u_int8_t attrValue = 1;
//
//    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
//    return result == 0;
//    }

//    - (NSString *)createFilePath:(NSString *)fileName
//    {
//    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"+"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
//    return filePath;
//    }
}
