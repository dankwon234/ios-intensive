//
//  SlidesViewController.swift
//  first-views
//
//  Created by Dan Kwon on 4/4/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit

class SlidesViewController: UIViewController {
    
    @IBOutlet var teamImage: UIImageView!
    @IBOutlet var imageScrollView: UIScrollView!
    var imagesArray = ["mets.png", "yankees.png", "redsox.png"]
    var index = 0


    @IBAction func showTeamImage(sender: UIButton){
        let team = sender.titleLabel?.text
        print("showTeam: \(team!)")
        
        let imageMap = ["mets":"mets.png", "yankees":"yankees.png", "red sox":"redsox.png"]
        self.teamImage.image = UIImage(named: imageMap[team!]!)
    }

    @IBAction func showNextImage(){
        print("showNextImage")
        index = index+1
        
        if (index == self.imagesArray.count){ // reset
            index = 0
        }
        
        
        let nextImage = self.imagesArray[index]
        
        self.teamImage.image = UIImage(named: nextImage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageScrollView.contentSize = CGSize(width: 600, height: 200)
        self.imageScrollView.pagingEnabled = true
        self.imageScrollView.showsHorizontalScrollIndicator = false
        
        let firstView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        firstView.backgroundColor = UIColor.redColor()
        self.imageScrollView.addSubview(firstView)

        let secondView = UIView(frame: CGRect(x: 200, y: 0, width: 200, height: 200))
        secondView.backgroundColor = UIColor.blueColor()
        self.imageScrollView.addSubview(secondView)

        let thirdView = UIView(frame: CGRect(x: 400, y: 0, width: 200, height: 200))
        thirdView.backgroundColor = UIColor.greenColor()
        self.imageScrollView.addSubview(thirdView)

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
