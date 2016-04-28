//  CLChannelViewController.swift
//  channel
//
//  Created by Dan Kwon on 4/8/16.
//  Copyright © 2016 fullstack360. All rights reserved.


import UIKit
import Firebase
import Alamofire


class CLChannelViewController: CLViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    var commentTextField: UITextField!
    var channel: CLChannel!
    var firebaseRef: Firebase!
    var postsArray = Array<CLPost>()
    var postsDict = Dictionary<String, CLPost>()
    
    // image stuff
    var imagePicker: UIImagePickerController?
    var selectedImage: UIImage?
    var imageKey: String?
    
    // Table
    var postsTable: UITableView!
    var headerView: UIView!
    var numReloads = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: #selector(CLChannelViewController.shiftKeyboardUp(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(CLChannelViewController.shiftKeyboardDown(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    deinit {
        print("DE INIT")
    }
    

    override func loadView() {
        self.title = self.channel.name
        let view = self.baseView(UIColor.blueColor())
        let frame = UIScreen.mainScreen().bounds
        
        let rgba = CGFloat(0.97)
        self.postsTable = UITableView(frame: frame, style: .Plain)
        self.postsTable.dataSource = self
        self.postsTable.delegate = self
        self.postsTable.backgroundColor = UIColor(red: rgba, green: rgba, blue: rgba, alpha: 1)
        self.postsTable.separatorStyle = .None
        self.postsTable.autoresizingMask = .FlexibleHeight
        self.postsTable.showsVerticalScrollIndicator = false
        self.postsTable.contentInset = UIEdgeInsetsMake(0, 0, 38+CLTableViewCellConstants.padding, 0)
        view.addSubview(self.postsTable)
        
        let padding = CGFloat(5)
        let h = CGFloat(38)
        
        let width = frame.size.width
        self.headerView = UIView(frame: CGRect(x: 0, y: frame.size.height-h, width: width, height: h))
        self.headerView.autoresizingMask = .FlexibleTopMargin
        let rgb = CGFloat(0.88)
        self.headerView.backgroundColor = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1)
        
        let btnImage = UIButton(type: .Custom)
        let dimen = h-2*padding
        btnImage.frame = CGRect(x: padding, y: padding, width: dimen, height: dimen)
        btnImage.backgroundColor = UIColor.redColor()
        btnImage.addTarget(self, action: #selector(CLChannelViewController.selectImage(_:)), forControlEvents: .TouchUpInside)
        self.headerView.addSubview(btnImage)
        
        
        self.commentTextField = UITextField(frame: CGRect(x: dimen+2*padding, y: padding, width: width-3*padding-dimen, height: h-2*padding))
        self.commentTextField.delegate = self
        self.commentTextField.autocorrectionType = .No
        self.commentTextField.borderStyle = .RoundedRect
        self.headerView.addSubview(self.commentTextField)
        view.addSubview(self.headerView)
        
        self.view = view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        self.navigationController?.navigationBarHidden = false
        
        // Create a reference to a Firebase location
        let firebaseUrl = Constants.kFiresbaseUrl+"channels/"+self.channel.id+"/posts"
        
        self.firebaseRef = Firebase(url: firebaseUrl)
        self.firebaseRef.queryLimitedToLast(25).observeEventType(.Value, withBlock: { snapshot in
            if let room = snapshot.value as? Dictionary<String, AnyObject> {
                print("\(room)")
                let keys = Array(room.keys)
                
                for key in keys {
                    if (self.postsDict[key] != nil){
                        continue
                    }
                    
                    let postInfo = room[key] as! Dictionary<String, AnyObject>
                    let post = CLPost()
                    post.populate(postInfo)
                    self.postsDict[key] = post
                    self.postsArray.append(post)
                }
                
                self.postsArray.sortInPlace { $0.timestamp.compare($1.timestamp) == .OrderedAscending }  // use `sort` in Swift 1.2
                self.postsTable.reloadData()
                
                let animated = (self.numReloads == 0) ? false : true
                let indexPath = NSIndexPath(forRow: self.postsArray.count-1, inSection: 0)
                self.postsTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: animated)
                self.numReloads = self.numReloads+1
            }
            
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func selectImage(btn: UIButton){
        print("selectImage")
        let actionSheet = UIActionSheet(title: "Select Source",
                                        delegate: self,
                                        cancelButtonTitle: "Cancel",
                                        destructiveButtonTitle: nil,
                                        otherButtonTitles: "Camera", "Photo Library")
        
        
        actionSheet.frame = CGRectMake(0, 150, self.view.frame.size.width, 100)
        actionSheet.actionSheetStyle = .BlackOpaque
        actionSheet.showInView(UIApplication.sharedApplication().keyWindow!)
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
        
        if (self.imagePicker == nil){
            self.imagePicker = UIImagePickerController()
        }
        
        self.imagePicker?.sourceType = sourceType
        self.imagePicker?.delegate = self
        self.presentViewController(self.imagePicker!, animated: true, completion: nil)
    }
    
    func shiftKeyboardUp(notification: NSNotification){
        var frame = self.headerView.frame
        frame.origin.y = 250
        self.headerView.frame = frame

//        if let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
//        print("\(notification.userInfo!)")
//            var frame = self.headerView.frame
//            frame.origin.y = 244
//            self.headerView.frame = frame
//        }
    }
    
    func shiftKeyboardDown(notification: NSNotification){
        var frame = self.headerView.frame
        frame.origin.y = self.view.frame.size.height-frame.size.height
        self.headerView.frame = frame
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.sendPost()
        return true
    }
    
    func sendPost(){
        if (self.selectedImage != nil){ // upload image
            self.startUpload()
            return
        }
        
        
        let imageId = (self.imageKey == nil) ? "" : self.imageKey!
        let post = ["text":self.commentTextField.text!, "from":"anonymous", "timesatmp":NSDate().timeIntervalSince1970, "image":imageId, "video":""]
        
//        let post = ["text":self.commentTextField.text!, "from":"anonymous", "timesatmp":NSDate().timeIntervalSince1970, "image":"", "video":""]

        let postRef = self.firebaseRef.childByAutoId()
        postRef.setValue(post, withCompletionBlock: { (error, firebase) in
            dispatch_async(dispatch_get_main_queue(), {
                self.commentTextField.text = nil
                
            })
        })
        
        self.commentTextField.resignFirstResponder()
        return
        
    }
    
    func startUpload(){
        if (self.selectedImage == nil){
            return
        }
        
        let networkMgr = CLNetworkManager.sharedInstance
        let url = "https://media-service.appspot.com/api/upload"
        networkMgr.getRequest(url, params: nil, completion: { (error, response) in
            if let uploadStr = response?["upload"] as? String {

                let imageData = UIImageJPEGRepresentation(self.selectedImage!, 0.5)
                let pkg = ["data":imageData!, "name":"image.jpg"]
                networkMgr.uplaodImageData(uploadStr, postData: pkg, completion: { (error, response) in
                    if (error != nil){
                        print("ERROR: \(error)")
                        return
                    }
                    
                    if let imageId = response!["id"] as? String {
                        self.imageKey = imageId
                        self.selectedImage = nil
                        self.sendPost()
                    }
                    
                })
            }
        })
    }
    
    
    
    
    // MARK: - ImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.selectedImage = image
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - TableView
    func scrollViewWillBeginDragging(scrollView: UIScrollView){
        self.commentTextField.resignFirstResponder()
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cellId"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CLTableViewCell {
            self.configureCell(cell, indexPath: indexPath)
            return cell
        }
        
        let cell = CLTableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let frame = tableView.frame
        let w = frame.size.width-2*CLTableViewCellConstants.padding
        let lblTextWidth = w-CLTableViewCellConstants.cellHeight

        let post = self.postsArray[indexPath.row]
        let str = NSString(string: post.text)
        let font = UIFont(name: CLTableViewCellConstants.font, size: 10)
        let bounds = str.boundingRectWithSize(CGSizeMake(lblTextWidth, 150),
                                              options: .UsesLineFragmentOrigin,
                                              attributes: [NSFontAttributeName:font!],
                                              context: nil)
        
        let extraHeight = (bounds.size.height > CLTableViewCellConstants.maxTextLabelHeight) ? (bounds.size.height-CLTableViewCellConstants.maxTextLabelHeight) : 0
        
        return CLTableViewCellConstants.cellHeight+extraHeight
        
    }

    func configureCell(cell: CLTableViewCell, indexPath: NSIndexPath){
        let post = self.postsArray[indexPath.row]
        cell.lblText.text = post.text
        cell.lblTimestamp?.text = post.formattedDate
        if (post.image == ""){
            cell.icon?.image = nil
            return
        }
        
        if (post.imageData == nil){
            cell.icon?.image = nil
            post.addObserver(self, forKeyPath: "imageData", options: .Initial, context: nil)
            post.fetchImage()
            return
        }
        
        cell.icon?.image = post.imageData
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        dispatch_async(dispatch_get_main_queue(), {
            let post = object as? CLPost
            post?.removeObserver(self, forKeyPath: "imageData")
            self.postsTable.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
