//
//  CLTableViewCell.swift
//  channel
//
//  Created by Dan Kwon on 4/24/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit

struct CLTableViewCellConstants {
    static let cellHeight = CGFloat(108)
    static let padding = CGFloat(12)
    static let maxTextLabelHeight = CGFloat(60)
    static let font = "Heiti SC"
}


class CLTableViewCell: UITableViewCell {
    
    var baseView: UIView!
    var icon: UIImageView!
    var lblTimestamp: UILabel!
    var lblText: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        let frame = UIScreen.mainScreen().bounds
        
        self.backgroundColor = .clearColor()
        
        let rgba = CGFloat(0.9)
        let p = CLTableViewCellConstants.padding
        let width = frame.size.width-2*p
        
        self.baseView = UIView(frame: CGRect(x: p, y: p, width: width, height: CLTableViewCellConstants.cellHeight-p))
        self.baseView.layer.borderColor = UIColor(red: rgba, green: rgba, blue: rgba, alpha: 1).CGColor
        self.baseView.layer.borderWidth = 1
        self.baseView.layer.masksToBounds = true
        self.baseView.layer.cornerRadius = 3.0
        self.baseView.backgroundColor = .whiteColor()
        
        self.lblTimestamp = UILabel(frame: CGRect(x: p, y: p, width: width-2*p, height: 10))
        self.lblTimestamp.backgroundColor = .clearColor()
        self.lblTimestamp.textAlignment = .Right
        self.lblTimestamp.font = UIFont(name: CLTableViewCellConstants.font, size: 8)
        self.lblTimestamp.textColor = UIColor(red: 0.5, green: 0.5, blue: 1, alpha: 1)
        self.baseView.addSubview(self.lblTimestamp)
    
        let dimen = self.baseView.frame.size.height-2*p
        self.icon = UIImageView(frame: CGRect(x: p, y: p, width: dimen, height: dimen))
        self.icon.backgroundColor = .redColor()
        self.icon.layer.cornerRadius = 0.5*dimen
        self.icon.layer.masksToBounds = true
        self.baseView.addSubview(self.icon)

        let x = self.baseView.frame.size.height
        self.lblText = UILabel(frame: CGRect(x: x, y: 2*p, width: width-x-p, height: 22))
        self.lblText.numberOfLines = 0
        self.lblText.lineBreakMode = .ByWordWrapping
        self.lblText.font = UIFont(name: CLTableViewCellConstants.font, size: 10)
        self.lblText.textColor = .darkGrayColor()
        self.lblText.backgroundColor = .clearColor()
        self.lblText.addObserver(self, forKeyPath: "text", options: .Initial, context: nil)
        self.baseView.addSubview(self.lblText)

        self.contentView.addSubview(self.baseView)
    }
    
    deinit {
        print("CLTableViewCell: DE INIT")
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if (keyPath != "text"){
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            let str = NSString(string: self.lblText.text!)
            var frame = self.lblText.frame
            let bounds = str.boundingRectWithSize(CGSizeMake(frame.size.width, 150),
                options: .UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName:self.lblText.font],
                context: nil)
            
            frame.size.height = bounds.size.height
            self.lblText.frame = frame
            
            if (frame.size.height < CLTableViewCellConstants.maxTextLabelHeight){
                let originalHeight = CLTableViewCellConstants.cellHeight-CLTableViewCellConstants.padding
                if (self.baseView.frame.size.height == originalHeight){
                    return
                }
                
                frame = self.baseView.frame
                frame.size.height = originalHeight
                self.baseView.frame = frame
                return
            }
            
            frame = self.baseView.frame
            frame.size.height += (bounds.size.height-CLTableViewCellConstants.maxTextLabelHeight)
            self.baseView.frame = frame
        })
        
        
        
    }

}
