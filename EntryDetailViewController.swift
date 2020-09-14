//
//  EntryDetailViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 14.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

protocol EntryDetailDelegate {
    func updateCell()
}

class EntryDetailViewController: UIViewController {
    
    var delegate: EntryDetailDelegate?
    
    var name = ""
    var cost = ""
    var signIndex = 0
    var color = UIColor()
    var date = Date()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var signSegmentedControl: UISegmentedControl!
    @IBOutlet weak var costTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Изменение заголовка карточки записи на Приход/Расход
        changeTitleLabel(to: signIndex)
        
        // Изменение названия
        nameTextField.text = name
        
        // Изменение знака Приход/Расход и стоимости
        signSegmentedControl.selectedSegmentIndex = signIndex
        changeSelectedSegmentColor(to: signIndex)
        costTextField.text = cost
        
        // Установка правильной русской локализации datePicker
        datePicker.locale = Locale.init(identifier: "ru")
        datePicker.date = date
        
    }
    
    func changeTitleLabel(to titleIndex: Int){
        switch titleIndex {
        case 0: self.titleLabel.text = "Приход"
        case 1: self.titleLabel.text = "Расход"
        default: break
        }
        
    }
    
    func changeSelectedSegmentColor(to colorIndex: Int){
        switch colorIndex {
        case 0: signSegmentedControl.selectedSegmentTintColor = UIColor.green
        case 1: signSegmentedControl.selectedSegmentTintColor = UIColor.red
        default:
            break
        }
    }
    
    @IBAction func changeEntryType(_ sender: Any) {
        changeSelectedSegmentColor(to: signSegmentedControl.selectedSegmentIndex)
        changeTitleLabel(to: signSegmentedControl.selectedSegmentIndex)
    }
    
}
