//
//  NewCategoryViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 18.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

//MARK: NewCategoryDelegate
protocol NewCategoryDelegate {
    func saveNewCategory(_ cat: MyCategory)
}

class NewCategoryViewController: UIViewController {

    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var iconsCollectionView: UICollectionView!
    @IBOutlet weak var saveCategoryButton: UIButton!
    
    var newCat = MyCategory()
    var delegate: NewCategoryDelegate?
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: act saveCategory
    
    @IBAction func saveCategory(_ sender: Any) {
        newCat.name = categoryNameTextField.text == "" ? "Новая категория" : categoryNameTextField.text!
        print(newCat)
        delegate?.saveNewCategory(newCat)
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: ext CollectionView
extension NewCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //MARK: numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IconNames.allCases.count
    }
    //MARK: cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconView", for: indexPath) as! IconCollectionViewCell
        
        cell.iconImageView.image = UIImage(systemName: getIconName(from: indexPath.row))
        cell.iconImageView.tintColor = myColors.red
        
        return cell
    }

    //MARK: didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newCat.iconName = getIconName(from: indexPath.row)
    }
    
    //MARK: sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = self.view.bounds.height / 6
        let w = self.view.bounds.width / 6
        
        return CGSize(width: w, height: h)
    }
    
}
