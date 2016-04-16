//
//  IGItemViewController.swift
//  instagram-api
//
//  Created by Dan Kwon on 4/14/16.
//  Copyright © 2016 fullstack360. All rights reserved.


import UIKit

class IGItemViewController: IGViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    var item: IGItem!
    var commentsTable: UITableView!
    var itemImageView: UIImageView!
    var lblCaption: UILabel!
    var lblDate: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.edgesForExtendedLayout = .None
    }
    
//    override func loadView() {
//        let frame = UIScreen.mainScreen().bounds
//        let view = UIView(frame: frame)
//        view.backgroundColor = UIColor.redColor()
//        
//        self.commentsTable = UITableView(frame: frame, style: .Plain)
//        self.commentsTable.dataSource = self
//        self.commentsTable.delegate = self
//        
//        let itemImageView = UIImageView(image: self.item.image)
//        itemImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
//        self.commentsTable.tableHeaderView = itemImageView
//        
//        view.addSubview(self.commentsTable)
//        
//        self.view = view
//    }

    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.whiteColor()
        
        self.itemImageView = UIImageView(image: self.item.image)
        self.itemImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.itemImageView.bounds
        let blk = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        gradient.colors = [UIColor.clearColor().CGColor, blk.CGColor]
        self.itemImageView.layer.insertSublayer(gradient, atIndex: 0)
        view.addSubview(self.itemImageView)
        
        let imgRibbon = UIImage(named: "ribbon.png")
        let w = imgRibbon!.size.width
        let h = imgRibbon!.size.height
        self.lblDate = UILabel(frame: CGRect(x: frame.size.width-w, y: 20, width: w, height: h))
        self.lblDate.font = UIFont(name: "Arial", size: 14)
        self.lblDate.backgroundColor = UIColor(patternImage: imgRibbon!)
        self.lblDate.textColor = UIColor.whiteColor()
        self.lblDate.text = "       "+self.item.formattedDate!
        self.lblDate.textAlignment = .Center
        view.addSubview(self.lblDate)
        
        

//        let font = UIFont(name: "Heiti SC", size: 18)
        let font = UIFont.systemFontOfSize(16)
        let cap = NSString(string: self.item.caption)
        let bounds = cap.boundingRectWithSize(CGSizeMake(frame.size.width-24, 1000), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        let height = bounds.size.height
        
        self.lblCaption = UILabel(frame: CGRect(x: 12, y: self.itemImageView.frame.size.height-height-12, width: frame.size.width-24, height: height))
        self.lblCaption.lineBreakMode = .ByWordWrapping
        self.lblCaption.numberOfLines = 0
        self.lblCaption.textColor = UIColor.whiteColor()
        self.lblCaption.font = font
        self.lblCaption.text = self.item.caption
        view.addSubview(self.lblCaption)
        

        self.commentsTable = UITableView(frame: frame, style: .Plain)
        self.commentsTable.dataSource = self
        self.commentsTable.delegate = self
        self.commentsTable.contentInset = UIEdgeInsetsMake(frame.size.width, 0.0, 0.0, 0.0)
        self.commentsTable.backgroundColor = UIColor.clearColor()
        
        
        view.addSubview(self.commentsTable)
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = -1*scrollView.contentOffset.y
//        print("\(offsetY)")
        
        // 320 = original position
        // 160 = disappear
        let max = scrollView.frame.size.width // 320
        let min = 0.5*max // 160
        let span = max-min
        
        let delta = max-offsetY
        let alpha = (min-delta)/span
//        print("ALPHA: \(alpha)")
        self.itemImageView.alpha = alpha
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.item.comments.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let comment = self.item.comments[indexPath.row]
        
        let cellId = "cellId"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId) {
            cell.textLabel?.text = comment["text"] as? String
            return cell
        }

        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = comment["text"] as? String
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
