//
//  DKChatViewController.swift
//  celebrities
//
//  Created by Dan Kwon on 4/6/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit

class DKChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: - Properties
    var chatTable: UITableView!
    var commentsArray = Array<String>()
    
    
    // MARK: - LifeCycle Methods

    override func loadView() {
        self.commentsArray.append("HEY!")
        self.commentsArray.append("This is awesome")
        self.commentsArray.append("I'm hungry")
        
        
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.redColor()
        
        self.chatTable = UITableView(frame: frame, style: .Plain)
        self.chatTable.dataSource = self
        self.chatTable.delegate = self
        
        let width = frame.size.width
        let chatBox = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 64))
        chatBox.backgroundColor = UIColor.yellowColor()
        
        let chatField = UITextField(frame: CGRect(x: 10, y: 10, width: width-20, height: 44))
        chatField.delegate = self
        chatField.borderStyle = .RoundedRect
        chatBox.addSubview(chatField)
        
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
        self.commentsArray.append(comment!)
        self.chatTable.reloadData()
        textField.text = nil
        
        
        
        
        return true
    }
    
    
    // MARK: - DataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentsArray.count // allocate number rows for the table view
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let comment = self.commentsArray[indexPath.row]
        
        let cellId = "cellId"
        
        // REUSE CELL:
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId) {
            cell.textLabel?.text = comment
            return cell
        }

        // CREATE NEW CELL:
        print("CREATE NEW CELL")
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = comment
        return cell
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
