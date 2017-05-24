//
//  CustomCollectionViewCell.swift
//  MultipleSelectionCollectionVIew
//
//  Created by Soumil Chugh on 22/05/17.
//  Copyright © 2017 Nagarro. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
 
    override var isSelected: Bool{
        didSet{
            self.backgroundColor = isSelected ? UIColor.black : UIColor.red
        }
    }
    
}
