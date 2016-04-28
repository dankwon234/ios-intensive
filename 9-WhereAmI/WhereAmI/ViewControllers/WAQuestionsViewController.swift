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
//        print("notificationReceived")
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.collectionView.reloadData()
    }
    
    func createQuestion(btn: UIBarButtonItem){
        print("createQuestion")
        let createQuestionVc = WACreateQuestionViewController()
        self.presentViewController(createQuestionVc, animated: true, completion: nil)
    }
    
    func configureCell(cell: WACollectionViewCell, indexPath :NSIndexPath){
        let question = self.questions[indexPath.row]
        if (question.imageData != nil){
            cell.imageView.image = question.imageData
            if (question.status == 0){
                cell.answerIcon.alpha = 0
            }
            else if (question.status == 1) {
                cell.answerIcon.alpha = 0.5
                cell.answerIcon.image = UIImage(named: "checkmark.png")
            }
            else {
                cell.answerIcon.alpha = 0.5
                cell.answerIcon.image = UIImage(named: "xmark.png")
            }
        }
        
        cell.imageView.image = nil
        if (question.status == 0){
            cell.answerIcon.alpha = 0
        }
        else if (question.status == 1) {
            cell.answerIcon.alpha = 0.5
            cell.answerIcon.image = UIImage(named: "checkmark.png")
        }
        else {
            cell.answerIcon.alpha = 0.5
            cell.answerIcon.image = UIImage(named: "xmark.png")
        }
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
            if (question.status == 0){
                cell.answerIcon.alpha = 0
            }
            else if (question.status == 1) {
                cell.answerIcon.alpha = 0.5
                cell.answerIcon.image = UIImage(named: "checkmark.png")
            }
            else {
                cell.answerIcon.alpha = 0.5
                cell.answerIcon.image = UIImage(named: "xmark.png")
            }
            
            return cell
        }
        
        
        cell.imageView.image = nil
        if (question.status == 0){
            cell.answerIcon.alpha = 0
        }
        else if (question.status == 1) {
            cell.answerIcon.alpha = 0.5
            cell.answerIcon.image = UIImage(named: "checkmark.png")
        }
        else {
            cell.answerIcon.alpha = 0.5
            cell.answerIcon.image = UIImage(named: "xmark.png")
        }

        question.fetchImage()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let question = self.questions[indexPath.row]
        print(question.answer)
        if (question.status != 0){ // already answered, ignore
            return
        }
        
        let questionVc = WAQuestionViewController()
        questionVc.question = question
        self.navigationController?.pushViewController(questionVc, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
