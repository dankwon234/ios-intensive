//
//  WACreateQuestionViewController.swift
//  WhereAmI
//
//  Created by Dan Kwon on 4/21/16.
//  Copyright © 2016 dankwon. All rights reserved.
//

import UIKit
import Alamofire

class WACreateQuestionViewController: WAViewController, UITextFieldDelegate {
    
    var image: UIImageView!
    var textFields = Array<UITextField>()
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.yellowColor()
        
        var padding = CGFloat(60)
        var y = CGFloat(64)
        var dimension = frame.size.width-2*padding
        
        
        self.image = UIImageView(frame: CGRect(x: padding, y: y, width: dimension, height: dimension))
        self.image.backgroundColor = UIColor.redColor()
        view.addSubview(self.image)
        
        let btnSelectImage = UIButton(frame: CGRect(x: padding, y: y, width: dimension, height: 44))
        btnSelectImage.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        btnSelectImage.setTitle("Tap to Select Image", forState: .Normal)
        view.addSubview(btnSelectImage)
        
        
        y += self.image.frame.size.height+24
        
        padding = 20
        let width = frame.size.width-2*padding
        for i in 0..<4 {
            let textField = UITextField(frame: CGRect(x: padding, y: y, width: width, height: 32))
            textField.delegate = self
            textField.borderStyle = .RoundedRect
            textField.placeholder = (i==0) ? "Correct Answer" : "Option \(i+1)"
            textField.returnKeyType = (i==3) ? .Done : .Next
            view.addSubview(textField)
            self.textFields.append(textField)
            y += textField.frame.size.height+16
        }
        
        dimension = 0.5*(frame.size.width-(3*padding))
        y = frame.size.height-44-padding
        
        let btnCancel = UIButton(frame: CGRect(x: padding, y: y, width: dimension, height: 44))
        btnCancel.backgroundColor = UIColor.blackColor()
        btnCancel.setTitle("Cancel", forState: .Normal)
        btnCancel.addTarget(self, action: #selector(WACreateQuestionViewController.cancel(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(btnCancel)
        
        let btnCreate = UIButton(frame: CGRect(x: frame.size.width-dimension-padding, y: y, width: dimension, height: 44))
        btnCreate.backgroundColor = UIColor.blackColor()
        btnCreate.setTitle("Create", forState: .Normal)
        btnCreate.addTarget(self, action: #selector(WACreateQuestionViewController.createQuestion(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(btnCreate)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WACreateQuestionViewController.dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
        
        self.view = view
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func dismissKeyboard(sender: UIGestureRecognizer?){
        for textField in self.textFields {
            if (textField.isFirstResponder()){
                textField.resignFirstResponder() // make keyboard go away
                self.shiftView(0)

                break
            }
            
        }
    }

    func cancel(btn: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createQuestion(btn: UIButton){
        print("createQuestion: ")
        
        var params = Dictionary<String, AnyObject>()
        var options = Array<String>()
        
        var valid = true
        for i in 0..<self.textFields.count {
            let textField = self.textFields[i]
            let option = textField.text!
//            print("\(option)")
            if (option.characters.count == 0){ // empty field, do not continue!
                valid = false
                break
            }
            
            if (i==0){
                params["answer"] = option
            }
            else {
                options.append(option)
            }
            
        }
        
        if (valid == false){
            print("Cannot Submit Question")
        }
        
        params["options"] = options
        print("Submit Question: \(params)")
        
        let url = "http://localhost:3000/api/question"
        Alamofire.request(.POST, url, parameters: params).responseJSON { response in
            if let JSON = response.result.value as? Dictionary<String, AnyObject>{
                print("\(JSON)")
            }
            
        }

    
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let index = self.textFields.indexOf(textField)!
        if (index == self.textFields.count-1){ // last one, ignore (for now)
            self.dismissKeyboard(nil)
            return true
        }
        
        let nextTextField = self.textFields[index+1]
        nextTextField.becomeFirstResponder()
        
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        // shift view up:
        self.shiftView(-150)
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
