//
//  ViewController.swift
//  celebrities
//
//  Created by Dan Kwon on 4/6/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageRihanna: UIImageView!
    @IBOutlet var imageLeonardo: UIImageView!
    @IBOutlet var imageTaylorSwift: UIImageView!
    @IBOutlet var selectedLabel: UILabel!
    
    var celebritiesDict = [String: DKCelebrity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leonardoDiCaprio = DKCelebrity()
        leonardoDiCaprio.name = "Leonardo DiCaprio"
        leonardoDiCaprio.image = "leonard.png"
        self.celebritiesDict[leonardoDiCaprio.name] = leonardoDiCaprio

        let rihanna = DKCelebrity()
        rihanna.name = "Rihanna"
        rihanna.image = "rihanna.png"
        self.celebritiesDict[rihanna.name] = rihanna

        let taylorSwift = DKCelebrity()
        taylorSwift.name = "Taylor Swift"
        taylorSwift.image = "taylor.png"
        self.celebritiesDict[taylorSwift.name] = taylorSwift
        

        let celebrities = [self.imageRihanna, self.imageLeonardo, self.imageTaylorSwift]
        
        for celebrityImage in celebrities {
            let selector = #selector(ViewController.selectCelebrity(_:))
            let tapGesture = UITapGestureRecognizer(target: self, action: selector)
            celebrityImage.addGestureRecognizer(tapGesture)
        }

    }
    
    func selectCelebrity(sender: UIGestureRecognizer){
        let view = sender.view
        print("selectCelebrity: \(view!.tag)")
        
        switch view!.tag {
        case 0:
            self.selectedLabel.text = "Leonardo DiCaprio"
        case 1:
            self.selectedLabel.text = "Rihanna"
        case 2:
            self.selectedLabel.text = "Taylor Swift"
        default:
            self.selectedLabel.text = ""
        }
    }
    
    @IBAction func showChatViewController(){
        print("showChatViewController")
        
        let chatVc = DKChatViewController()
        let selectedCelebrity = self.celebritiesDict[self.selectedLabel.text!]
        chatVc.selectedCelebrity = selectedCelebrity
        self.navigationController?.pushViewController(chatVc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

