//
//  CLCreateChannelViewController.swift
//  channel
//
//  Created by Dan Kwon on 4/16/16.
//  Copyright © 2016 fullstack360. All rights reserved.


import UIKit
import CoreLocation

class CLCreateChannelViewController: CLViewController, UITextFieldDelegate {
    

    static let fields = ["name", "address", "image", "password"]
    var channel: CLChannel!
    var field: UITextField!
    var lblCityState: UILabel!
    var btnNext: UIButton!
    var pageControl: UIPageControl!
    var step: Int!
    var loc: CLLocation?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Create Channel"
    }

    override func loadView() {
        var placeholder = ""
        var bgColor = UIColor.whiteColor()
        var btnText = ""
        switch self.step {
            case 0:
                placeholder = "Name of Place"
                bgColor = UIColor(red: 0.25, green: 0.25, blue: 1, alpha: 1)
                btnText = "Next"
            
            case 1:
                placeholder = "Address of Place"
                bgColor = UIColor(red: 0.8, green: 0.25, blue: 0.25, alpha: 1)
                btnText = "Next"
            
            case 2:
                placeholder = "Image (Optional)"
                bgColor = UIColor(red: 0.25, green: 0.75, blue: 0.25, alpha: 1)
                btnText = "Next"
            
            case 3:
                placeholder = "Password"
                bgColor = UIColor(red: 0.25, green: 0.75, blue: 0.25, alpha: 1)
                btnText = "Finish"
            default:
                break
        }

        
        let view = self.baseView(bgColor)
        let frame = UIScreen.mainScreen().bounds
        
        
        let padding = CGFloat(20)
        
        let xMark = UIImage(named: "x-mark.png")
        let btnCancel = UIButton(frame: CGRect(x: padding, y: 2*padding, width: xMark!.size.width, height: xMark!.size.height))
        btnCancel.autoresizingMask = .FlexibleTopMargin
        btnCancel.setImage(xMark, forState: .Normal)
        btnCancel.addTarget(self, action: #selector(CLCreateChannelViewController.cancel(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(btnCancel)
        
        
        var y = 0.30*frame.size.height
        let h = CGFloat(32)
        let width = frame.size.width-2*padding
        
        self.field = UITextField(frame: CGRect(x: padding, y: y, width: width, height: h))
        self.field.delegate = self
        self.field.autoresizingMask = .FlexibleTopMargin
        self.field.font = UIFont(name: "Heiti SC", size: 16)
        self.field.textColor = .whiteColor()
        self.field.autocorrectionType = .No
        self.field.borderStyle = .None
        
        let transparent = UIColor(red: 1, green: 1, blue: 1, alpha: 0.65)
        self.field.attributedPlaceholder = NSAttributedString(string:placeholder, attributes: [NSForegroundColorAttributeName: transparent])
        
        view.addSubview(self.field)
        y += self.field.frame.size.height
        
        self.lblCityState = UILabel(frame: CGRect(x:padding, y:y, width:width, height:14))
        self.lblCityState.textColor = UIColor.whiteColor()
        self.lblCityState.textAlignment = .Right
        self.lblCityState.font = UIFont.systemFontOfSize(12)
        self.lblCityState.alpha = 0
        view.addSubview(self.lblCityState)
        y += self.lblCityState.frame.size.height+padding
        
        self.btnNext = UIButton(frame: CGRect(x: padding, y: y, width: width, height: 44))
        self.btnNext.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnNext.setTitle(btnText, forState: .Normal)
        self.btnNext.titleLabel?.font = self.field.font
        self.btnNext.layer.borderColor = UIColor.whiteColor().CGColor
        self.btnNext.layer.borderWidth = 2.0
        self.btnNext.layer.cornerRadius = 0.5*self.btnNext.frame.size.height
        self.btnNext.alpha = 0
        self.btnNext.addTarget(self, action: #selector(CLCreateChannelViewController.nextSreen(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(self.btnNext)
        y += self.btnNext.frame.size.height+padding
        
        self.pageControl = UIPageControl(frame: CGRect(x: padding, y: y, width: width, height: 20))
        self.pageControl.numberOfPages = CLCreateChannelViewController.fields.count
        self.pageControl.currentPage = self.step
        self.pageControl.alpha = 0
        view.addSubview(self.pageControl)

        self.view = view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.step > 0){
            self.lblCityState.text = self.channel.city+", "+self.channel.state
            return
        }
        
        let geocode = CLGeocoder()
        
        // public typealias CLGeocodeCompletionHandler = ([CLPlacemark]?, NSError?) -> Void
        geocode.reverseGeocodeLocation(self.loc!, completionHandler: { (placemarks, error) in
            if (error != nil){
                return
            }
            
            if (placemarks?.count == 0){
                return
            }
            
            let placemark = placemarks?[0]
//            print("\(placemark?.addressDictionary?.description)")
            self.channel.city = placemark?.addressDictionary?["City"] as? String
            self.channel.state = placemark?.addressDictionary?["State"] as? String
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.field.becomeFirstResponder()
    }
    
    func nextSreen(btn: UIButton){
        let selectedField = CLCreateChannelViewController.fields[self.step]
        
        if (self.field.text?.characters.count == 0){
            let msg = "Please enter a "+selectedField
            let alert = UIAlertController(title: "Missing Value", message: msg, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        self.channel.setValue(self.field.text!, forKey: selectedField)
        print("\(self.channel.dictionaryRepresentation())")
        
        if (self.step < 2){
            let createChannelVc = CLCreateChannelViewController()
            createChannelVc.step = self.step+1
            createChannelVc.channel = self.channel
            self.navigationController?.pushViewController(createChannelVc, animated: true)
            return
        }
        
        // create channel
        let networkManager = CLNetworkManager.sharedInstance
        let url = Constants.kBaseUrl+"/api/channel"
        networkManager.postRequest(url, params: self.channel.dictionaryRepresentation(), completion: { (error, response) in
            if (error != nil){
                print("ERROR: \(error)")
                return
            }
            
//            print("\(response!)")
            dispatch_async(dispatch_get_main_queue(), {
                let result = response!["result"] as? Dictionary<String, AnyObject>
                self.channel.populate(result!)
                
                
                let channelVc = CLChannelViewController()
                channelVc.channel = self.channel
                self.navigationController?.pushViewController(channelVc, animated: true)
            })
        })
        
    }
    
    func cancel(btn: UIButton){
        if (self.step == 0){
            self.dismissViewControllerAnimated(true, completion: {
                
            })
            
            return
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func checkTextField(){
        let text = self.field.text!
        
        let alpha = (text.characters.count==0) ? CGFloat(0) : CGFloat(1)
        if (self.btnNext.alpha == alpha){
            return
        }
        
        UIView.animateWithDuration(0.4,
                                   animations: {
                                    self.btnNext.alpha = alpha
                                    self.pageControl.alpha = alpha
                                    
                                    if (self.step == 1){ // address label
                                        self.lblCityState.alpha = alpha
                                    }
                                    
            }, completion: nil)

    }
    
    // MARK: - TextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.performSelector(#selector(CLCreateChannelViewController.checkTextField), withObject: nil, afterDelay: 0.05)
        return true
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        /*
        if (tag == 1003){ // last text field, create channel
            

            var params = Dictionary<String, AnyObject>()
            for fieldName in self.fieldNames {
                let i = self.fieldNames.indexOf(fieldName)!
                let tf = self.view.viewWithTag(1000+i) as? UITextField
                if (tf?.text?.characters.count == 0){
                    let msg = "Please enter a "+fieldName
                    let alert = UIAlertController(title: "Missing Value", message: msg, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: {
                        
                    })
                    
                    return true
                }
                
                params[fieldName.lowercaseString] = tf?.text
            }
            
            params["state"] = "ny"
            print("CREATE CHANNEL: \(params)")
            
            let networkMgr = CLNetworkManager.sharedInstance
            networkMgr.createChannel(params, completion: { (error, response) in
                if (error != nil){
                    print("ERROR: \(error)")
                    return
                }

                print("SUCCESS: \(response)")
                if let channelInfo = response["result"] as? Dictionary<String, AnyObject>{
                    

                    dispatch_async(dispatch_get_main_queue(), {
                        let channel = CLChannel()
                        channel.populate(channelInfo)
                        let notificationCenter = NSNotificationCenter.defaultCenter()
                        let notification = NSNotification(name: Constants.kChannelCreatedNotification, object: nil, userInfo: ["channel":channel])
                        notificationCenter.postNotification(notification)
                        
                        self.dismissViewControllerAnimated(true, completion: {
                            
                        })
                    })
                }
                

            })
            
            
            return true
        }
         */
        
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
