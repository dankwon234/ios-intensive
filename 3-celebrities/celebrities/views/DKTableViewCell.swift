//
//  DKTableViewCell.swift
//  celebrities
//
//  Created by Dan Kwon on 4/7/16.
//  Copyright © 2016 fullstack360. All rights reserved.
//

import UIKit

class DKTableViewCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // here is way we customize the cell:
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let frame = UIScreen.mainScreen().bounds
        
        self.selectionStyle = .None
        
        self.textLabel?.textColor = UIColor.redColor()
        self.imageView?.layer.cornerRadius = 40
        self.imageView?.layer.masksToBounds = true
        
//        let starIcon = UIImageView(frame: CGRect(x: frame.size.width-28, y: 4, width: 24, height: 24))
//        starIcon.image = UIImage(named: "star.png")
//        self.contentView.addSubview(starIcon)
        
//        for (var i=0; i<3; i++){ // DEPRECATED! NO!
//            
//        }
        
        for var i in 0..<3{
            let offset = frame.size.width-24*(CGFloat(i)+1)-4
            let starIcon = UIImageView(frame: CGRect(x: offset, y: 4, width: 24, height: 24))
            starIcon.image = UIImage(named: "star.png")
            self.contentView.addSubview(starIcon)
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
