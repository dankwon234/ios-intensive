//
//  DKChatViewController.swift
//  celebrities
//
//  Created by Dan Kwon on 4/6/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit

class DKChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: - Properties
    var chatTable: UITableView!
    var selectedCelebrity: DKCelebrity!
    var chatField: UITextField!
    
    // MARK: - My Stuff

    func configureCell(cell: DKTableViewCell, indexPath: NSIndexPath){
        let comment = self.selectedCelebrity.comments[indexPath.row]
        cell.textLabel?.text = comment.text
        cell.detailTextLabel?.text = comment.timestamp.description
        cell.imageView?.image = UIImage(named: self.selectedCelebrity.image)
    }
    
    // MARK: - LifeCycle Methods

    override func loadView() {
        self.title = self.selectedCelebrity.name
        
        
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.redColor()
        
        self.chatTable = UITableView(frame: frame, style: .Plain)
        self.chatTable.dataSource = self
        self.chatTable.delegate = self
        self.chatTable.separatorStyle = .None
        
        let width = frame.size.width
        let chatBox = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 64))
        chatBox.backgroundColor = UIColor.yellowColor()
        
        self.chatField = UITextField(frame: CGRect(x: 10, y: 10, width: width-20, height: 44))
        self.chatField.delegate = self
        self.chatField.borderStyle = .RoundedRect
        chatBox.addSubview(self.chatField)
        
        self.chatTable.tableHeaderView = chatBox
        
        
        view.addSubview(self.chatTable)
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let comment = textField.text
        if (comment?.characters.count == 0){
            let alert = UIAlertController(title: "Help!", message: "I'm trapped in an alert box", preferredStyle: .Alert)
            
            let okBtn = UIAlertAction(title: "I'll save you", style: .Default, handler: nil)
            alert.addAction(okBtn)
            
            self.presentViewController(alert, animated: true, completion: nil)
            return true
        }
        
        let cmt = DKComment()
        cmt.text = comment!
        
        self.selectedCelebrity.comments.append(cmt)
        self.chatTable.reloadData()
        textField.text = nil
        
        return true
    }
    

    
    // MARK: - DataSource Methods
//    func scrollViewDidScroll(scrollView: UIScrollView){
//        self.chatField.resignFirstResponder()
//        
//    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.chatField.resignFirstResponder()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedCelebrity.comments.count // allocate number rows for the table view
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cellId"
        
        // REUSE CELL:
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? DKTableViewCell {
            self.configureCell(cell, indexPath: indexPath)
            return cell
        }

        // CREATE NEW CELL:
        let cell = DKTableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
//        let comment = self.commentsArray[indexPath.row]
//        print("didDeselectRowAtIndexPath: \(comment)")
//        
//    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
//        let comment = self.selectedCelebrity.comments[indexPath.row]
//        let commentText = NSString(string: comment.text)
//        let size =  commentText.boundingRectWithSize(CGSize(width: tableView.frame.width, height: 100),
//                                                                         options: NSStringDrawingOptions.UsesLineFragmentOrigin,
//                                                                         attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)],
//                                                                         context: nil).size
//        
//        
//        
//        return size.height+30
        
        
        return 88.0
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
