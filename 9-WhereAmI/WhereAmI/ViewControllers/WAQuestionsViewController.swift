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
    var icons = ["", "checkmark.png", "xmark.png"]
//    var imageCache = Dictionary<String, UIImage>()


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Questions"
        self.tabBarItem.image = UIImage(named: "question.png")
        
//        for i in 0..<self.icons.count {
//            let icon = self.icons[i]
//            if let image = UIImage(named: icon){
//                self.imageCache[icon] = image
//            }
//        }
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
                                       selector: #selector(WAQuestionsViewController.notificationReceived(_:)),
                                       name: "ImageDownloaded",
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(WAQuestionsViewController.questionCreated(_:)),
                                       name: "QuestionCreated",
                                       object: nil)

        


    }
    
    func notificationReceived(note: NSNotification){
//        print("notificationReceived")
        self.collectionView.reloadData()
        
    }
    
    func questionCreated(note: NSNotification){
        print("questionCreated: \(note)")
        if let question = note.userInfo?["question"] as? WAQuestion {
            self.questions.append(question)
            self.collectionView.reloadData()
        }
        
        
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
        
        let url = Constants.baseUrl+"/api/question"
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
        print("viewWillAppear: \(self.questions.count)")
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.collectionView.reloadData()
    }

    func createQuestion(btn: UIBarButtonItem){
        let createQuestionVc = WACreateQuestionViewController()
        print("createQuestion: \(self.questions.count)")
        self.presentViewController(createQuestionVc, animated: true, completion: nil)
    }
    
//    func configureCell(cell: WACollectionViewCell, indexPath :NSIndexPath){
//        let question = self.questions[indexPath.row]
//        
//        let icon = self.icons[question.status]
//        cell.answerIcon.image = self.imageCache[icon]
//        cell.answerIcon.alpha = (question.status == 0) ? 0 : 0.6
//        
//        if (question.imageData != nil){
//            cell.imageView.image = question.imageData
//            return
//        }
//        
//        cell.imageView.image = nil
//        question.fetchImage()
//    }
    
    func configureCell(cell: WACollectionViewCell, indexPath :NSIndexPath){
        let question = self.questions[indexPath.row]
        cell.answerIcon.image = UIImage(named: self.icons[question.status])
        cell.answerIcon.alpha = (question.status == 0) ? 0 : 0.6
        
        if (question.imageData != nil){
            cell.imageView.image = question.imageData
            return
        }
        
        cell.imageView.image = nil
        question.fetchImage()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellId = "cellId"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! WACollectionViewCell
        
        self.configureCell(cell, indexPath: indexPath)
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
