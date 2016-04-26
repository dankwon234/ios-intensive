//
//  WACollectionViewFlowLayout.swift
//  WhereAmI
//
//  Created by Dan Kwon on 4/26/16.
//  Copyright © 2016 dankwon. All rights reserved.
//

import UIKit

class WACollectionViewFlowLayout: UICollectionViewFlowLayout {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        let frame = UIScreen.mainScreen().bounds
        // 12+10+130+10+130+10+12 = 314
        
        let dimension = frame.size.width / 3
        self.itemSize = CGSizeMake(dimension, dimension)
        
        self.minimumInteritemSpacing = 0 // horizontal gap between columns
        self.minimumLineSpacing = 0 // vertical gap between rows
        self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
    }
    

}
