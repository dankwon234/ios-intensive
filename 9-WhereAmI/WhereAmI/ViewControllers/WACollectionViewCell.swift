//
//  WACollectionViewCell.swift
//  WhereAmI
//
//  Created by Dan Kwon on 4/26/16.
//  Copyright © 2016 dankwon. All rights reserved.
//

import UIKit

class WACollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.imageView.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(self.imageView)
    }
    
}







