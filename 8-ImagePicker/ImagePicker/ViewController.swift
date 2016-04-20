//
//  ViewController.swift
//  ImagePicker
//
//  Created by Dan Kwon on 4/19/16.
//  Copyright © 2016 dankwon. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
    
    var imagePicker: UIImagePickerController!
    @IBOutlet var selectedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func takePicture(){
        print("takePicture")
        let actionSheet = UIActionSheet(title: "Select Source",
                                        delegate: self,
                                        cancelButtonTitle: "Cancel",
                                        destructiveButtonTitle: nil,
                                        otherButtonTitles: "Camera", "Photo Library")
        

        actionSheet.frame = CGRectMake(0, 150, self.view.frame.size.width, 100)
        actionSheet.actionSheetStyle = .BlackOpaque
        actionSheet.showInView(UIApplication.sharedApplication().keyWindow!)
        
    }
    
    @IBAction func uploadImage(){
        if (self.selectedImageView.image == nil){
            return
        }
        
        let url = "https://media-service.appspot.com/api/upload"
        Alamofire.request(.GET, url, parameters: nil).responseJSON { response in
            if let JSON = response.result.value as? Dictionary<String, AnyObject>{
                print("\(JSON)")
                
                if let uploadStr = JSON["upload"] as? String {
                    let imageData = UIImageJPEGRepresentation(self.selectedImageView.image!, 0.5)
                    
                    self.uplaodImageData(uploadStr, postData: ["data":imageData!, "name":"image.jpg"], successHandler: { resp in
                        print("SUCCESS: \(resp)")
                        
                        }, failureHandler: { resp in
                            print("FAIL: \(resp)")
                            
                    })

                }
            }
        }
    }
    
    
    func uplaodImageData(requestURL: String, postData:[String:AnyObject], successHandler: (String) -> (),failureHandler: (String) -> ()) -> () {
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
                        }
                    }
                    
                case .Failure(let encodingError):
                    print("UPLOAD FAIL \(encodingError): ")
                }
            }
        )
        
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        print("clickedButtonAtIndex: \(buttonIndex)")
        
        var sourceType: UIImagePickerControllerSourceType
        if (buttonIndex == 1){
            sourceType = .Camera
        }
        else if (buttonIndex == 2){
            sourceType = .PhotoLibrary
        }
        else {
            return
        }

        self.imagePicker = UIImagePickerController()
        self.imagePicker.sourceType = sourceType
        self.imagePicker.delegate = self
        self.presentViewController(self.imagePicker, animated: true, completion: nil)

    }

    
    // MARK: - ImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("didFinishPickingMediaWithInfo: \(selectedImage)")
            
            self.selectedImageView.image = selectedImage
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

