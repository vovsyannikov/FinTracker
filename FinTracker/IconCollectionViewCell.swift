//
//  IconCollectionViewCell.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 18.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            layer.cornerRadius = 7
            UIView.animate(withDuration: 0.1) { [self] in
                backgroundColor = isSelected || isHighlighted ? .systemTeal : .white
            }
            
        }
    }
}
