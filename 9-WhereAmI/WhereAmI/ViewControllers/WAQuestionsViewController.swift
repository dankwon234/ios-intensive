//
//  WAQuestionsViewController.swift
//  WhereAmI
//
//  Created by Dan Kwon on 4/21/16.
//  Copyright © 2016 dankwon. All rights reserved.


import UIKit
import Alamofire

class WAQuestionsViewController: WAViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!
    var questions = Array<WAQuestion>()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Questions"
        self.tabBarItem.image = UIImage(named: "question.png")
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
                                       selector: #selector(WAQuestionsViewController.notificationReceived(_:)),
                                       name: "ImageDownloaded",
                                       object: nil)

    }
    
    func notificationReceived(note: NSNotification){
        print("notificationReceived")
        self.collectionView.reloadData()
        
    }
    

    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.whiteColor()
        
        let collectionViewLayout = WACollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.registerClass(WACollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cellId")
        view.addSubview(self.collectionView)

        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(WAQuestionsViewController.createQuestion(_:)))
        
        let url = "http://localhost:3000/api/question"
        Alamofire.request(.GET, url, parameters: nil).responseJSON { response in
            if let JSON = response.result.value as? Dictionary<String, AnyObject>{
                if let results = JSON["results"] as? Array<Dictionary<String, AnyObject>>{
                    
                    for i in 0..<results.count {
                        let info = results[i]
                        let question = WAQuestion()
                        question.populate(info)
                        self.questions.append(question)
                    }
                        
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectionView.reloadData()
                    })
                    
                }
            }
        }
    }
    
    func createQuestion(btn: UIBarButtonItem){
        print("createQuestion")
        let createQuestionVc = WACreateQuestionViewController()
        self.presentViewController(createQuestionVc, animated: true, completion: nil)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let question = self.questions[indexPath.row]
        
        let cellId = "cellId"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! WACollectionViewCell
        
        if (question.imageData != nil){
            cell.imageView.image = question.imageData
            return cell
        }
        
        
        cell.imageView.image = nil
        question.fetchImage()
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
