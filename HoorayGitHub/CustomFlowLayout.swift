//
//  CustomFlowLayout.swift
//  HoorayGitHub
//
//  Created by Francisco Ragland Jr on 11/13/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    init(columns: Int) {
        super.init()
        
        let frame = UIScreen.mainScreen().bounds
        let width = CGRectGetWidth(frame)
        
        let sizeWidth = (width / CGFloat(columns)) - 1.0
        
        self.itemSize = CGSize(width: sizeWidth, height: sizeWidth)
        self.minimumInteritemSpacing = 1.0
        self.minimumLineSpacing = 1.0
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
