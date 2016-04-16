//
//  IGFeedViewController.swift
//  instagram-api
//
//  Created by Dan Kwon on 4/13/16.
//  Copyright © 2016 fullstack360. All rights reserved.


import UIKit
import Alamofire

class IGFeedViewController: IGViewController, UITableViewDataSource, UITableViewDelegate {
    
    var itemsArray = Array<IGItem>()
    var itemsTable: UITableView!
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.redColor()
        
        self.itemsTable = UITableView(frame: frame, style: .Plain)
        self.itemsTable.dataSource = self
        self.itemsTable.delegate = self
        view.addSubview(self.itemsTable)
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "https://www.instagram.com/juicecrawl/media/"
        Alamofire.request(.GET, url, parameters: nil).responseJSON { response in
            if let JSON = response.result.value as? Dictionary<String, AnyObject>{
                if let items = JSON["items"] as? Array<Dictionary<String, AnyObject>>{
                    
                    for itemInfo in items {
                        let item = IGItem()
                        item.populate(itemInfo)
                        self.itemsArray.append(item)
                    }
                    
                    self.itemsTable.reloadData()
                }
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        dispatch_async(dispatch_get_main_queue(), {
            let item = object as? IGItem
            item?.removeObserver(self, forKeyPath: "image", context: nil)
            if (keyPath == "image"){
//                print("IMAGE DOWNLOADED!!!")
                self.itemsTable.reloadData()
            }
        })
    }

    func configureCell(cell:UITableViewCell, indexPath:NSIndexPath) -> UITableViewCell{
        let item = self.itemsArray[indexPath.row]
        cell.textLabel?.text = item.caption
        cell.detailTextLabel?.text = "\(item.comments.count) comments"
        
        if (item.image == nil){
            item.addObserver(self, forKeyPath: "image", options: .Initial, context:nil)
            cell.imageView?.image = nil
            item.fetchImage()
            return cell
        }
        
        cell.imageView?.image = item.image
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "cellId"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId) {
            return self.configureCell(cell, indexPath: indexPath)
        }
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        return self.configureCell(cell, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let item = self.itemsArray[indexPath.row]
        let itemVc = IGItemViewController()
        itemVc.item = item
        self.navigationController?.pushViewController(itemVc, animated: true)
        
        
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
