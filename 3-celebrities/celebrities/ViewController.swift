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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let celebrities = [self.imageRihanna, self.imageLeonardo, self.imageTaylorSwift]
        
        for celebrityImage in celebrities {
            let selector = #selector(ViewController.selectCelebrity(_:))
            let tapGesture = UITapGestureRecognizer(target: self, action: selector)
            celebrityImage.addGestureRecognizer(tapGesture)
        }

    }
    
    func selectCelebrity(sender: UIGestureRecognizer){
        
        print("selectCelebrity: ")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

