//
//  CustomCollectionViewCell.swift
//  MultipleSelectionCollectionVIew
//
//  Created by Soumil Chugh on 22/05/17.
//  Copyright © 2017 Nagarro. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var titleLabel: UILabel!
    override var isSelected: Bool{
        didSet{
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: { 
                self.backgroundColor = self.isSelected ? UIColor.green : UIColor.red
                self.transform = CGAffineTransform(scaleX: 0.5,y:0.5)
            }, completion: nil)
        }
    }
    
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.bounds.height/2
    }
}
