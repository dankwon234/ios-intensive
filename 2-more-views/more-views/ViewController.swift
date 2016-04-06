//
//  ViewController.swift
//  more-views
//
//  Created by Dan Kwon on 4/5/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var imageScroll: UIScrollView!
    var imagesArray = [
        "mets.png", "redsox.png", "yankees.png"
    ]
    
    var teamLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load")
        self.edgesForExtendedLayout = .None
        
        let frame = UIScreen.mainScreen().bounds // frame of the entire device
        
        self.teamLabel = UILabel(frame: CGRect(x: 20, y: 20, width: frame.size.width-40, height: 32))
//        self.teamLabel.backgroundColor = UIColor.grayColor()
        self.teamLabel.textColor = UIColor.orangeColor()
        self.teamLabel.textAlignment = .Center
        self.teamLabel.text = "Mets"
        self.view.addSubview(self.teamLabel)
        
        
        
        self.imageScroll.backgroundColor = UIColor.yellowColor()
        self.imageScroll.delegate = self
        let w = self.imagesArray.count * Int(self.imageScroll.frame.size.width)
        self.imageScroll.contentSize = CGSize(width: w, height: 0)
        self.imageScroll.pagingEnabled = true
        
        for image in self.imagesArray {
            let index = self.imagesArray.indexOf(image)
            let xOrigin = index!*200
            let imageView = UIImageView(frame: CGRect(x: xOrigin, y: 0, width: 200, height: 200))
            imageView.image = UIImage(named: image)
            self.imageScroll.addSubview(imageView)
        }
        
        
        let y = self.imageScroll.frame.origin.y+self.imageScroll.frame.size.height+30
        
        let btnNext = UIButton(type: .Custom)
        btnNext.autoresizingMask = .FlexibleTopMargin
        btnNext.frame = CGRect(x: 0, y: y, width: 200, height: 44)
        btnNext.center = CGPoint(x: 0.5*frame.size.width, y: btnNext.center.y)
        btnNext.backgroundColor = UIColor(red: 0.25, green: 0.75, blue: 0.5, alpha: 1)
        btnNext.layer.borderColor = UIColor.lightGrayColor().CGColor
        btnNext.layer.borderWidth = 1.0
        btnNext.layer.cornerRadius = 5.0
        btnNext.layer.masksToBounds = true
        btnNext.setTitle("Next", forState: .Normal)
        btnNext.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        btnNext.addTarget(self, action: #selector(ViewController.btnNextAction(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btnNext)
    }
    
    func btnNextAction(btn: UIButton){
        print("btnNextAction")
        let forumVc = DKForumViewController()
        forumVc.selectedTeam = self.teamLabel.text
        self.navigationController?.pushViewController(forumVc, animated: true)
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        print("scrollViewDidScroll: \(scrollView.contentOffset.x)")
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView){
        self.teamLabel.text = ""
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        print("scrollViewDidEndDecelerating: \(scrollView.contentOffset.x)")
        let offset = scrollView.contentOffset.x
        if (offset == 0){
            self.teamLabel.text = "Mets"
            self.teamLabel.textColor = UIColor.orangeColor()
        }
        if (offset == 200){
            self.teamLabel.text = "Red Sox"
            self.teamLabel.textColor = UIColor.redColor()
        }
        if (offset == 400){
            self.teamLabel.text = "Yankees"
            self.teamLabel.textColor = UIColor.blueColor()
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("View Will Appear")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("View Did Appear")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

