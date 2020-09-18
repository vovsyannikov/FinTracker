//
//  NewCategoryViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 18.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController {

    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var iconsCollectionView: UICollectionView!
    @IBOutlet weak var saveCategoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}

extension NewCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected \(indexPath.row): \(getIconName(from: indexPath.row))")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = self.view.bounds.height / 6
        let w = self.view.bounds.width / 6
        
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IconNames.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconView", for: indexPath) as! IconCollectionViewCell
        
        cell.iconImageView.image = UIImage(systemName: getIconName(from: indexPath.row).rawValue)
        cell.iconImageView.tintColor = myColors.red
        
        return cell
    }
    
    
}
