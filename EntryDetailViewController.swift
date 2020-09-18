//
//  EntryDetailViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 14.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

protocol EntryDetailDelegate {
    func updateCell(for entry: Entry, at index: Int)
    func createCell(for entry: Entry)
}

class EntryDetailViewController: UIViewController {
    
    var delegate: EntryDetailDelegate?
    
    var name = ""
    var cost = ""
    var signIndex = 0
    var color = UIColor()
    var date = Date()
    var cellIndex = 0
    var buttonName = "Другое"
    var isNew = false
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var signSegmentedControl: UISegmentedControl!
    @IBOutlet weak var costTextField: UITextField!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var pickerView: UIPickerView!
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
        datePicker.locale = Locale(identifier: "ru")
        datePicker.date = date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date(timeIntervalSinceNow: 10800)
        
        // Установка кнопки категории
        categoryButton.setAttributedTitle(underlinedText(from: "   \(buttonName)"), for: .normal)
        categoryButton.layer.borderWidth = 0.5
        categoryButton.layer.borderColor = UIColor.gray.cgColor
        categoryButton.layer.cornerRadius = 5
        
        changeSelectedSegmentColor(to: signIndex)
    }
    
    func underlinedText(from input: String) -> NSAttributedString {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        let resultingString = NSAttributedString(string: input, attributes: underlineAttribute)
        
        return resultingString
    }
    
    func fixedText(from input: String) -> NSAttributedString {
        let result: NSAttributedString = NSAttributedString(string: input)
        
        return result
    }
    
    func changeTitleLabel(to titleIndex: Int){
        switch titleIndex {
        case 0: self.titleLabel.text = "Приход"
        case 1: self.titleLabel.text = "Расход"
        default: break
        }
        
    }
    
    func changeCategoryButton(to cat: String) {
        let incomeString = "   \(EntryType.income.rawValue)"
        let outcomeString = cat == EntryType.other.rawValue || cat == EntryType.income.rawValue
            ? "   \(EntryType.other.rawValue)"
            : "   \(cat)"
        
        switch signIndex {
        case 0: do {
            categoryButton.setAttributedTitle(fixedText(from: incomeString), for: .normal)
            categoryButton.tintColor = UIColor.black
            categoryButton.isEnabled = false
        }
        case 1: do {
            categoryButton.setAttributedTitle(underlinedText(from: outcomeString), for: .normal)
            categoryButton.tintColor = UIColor.systemBlue
            categoryButton.isEnabled = true
        }
        default: break
        }
    }
    
    func changeSelectedSegmentColor(to colorIndex: Int){
        switch colorIndex {
        case 0: do{
            signSegmentedControl.selectedSegmentTintColor = myColors.green
            changeCategoryButton(to: EntryType.income.rawValue)
        }
        case 1: do {
            signSegmentedControl.selectedSegmentTintColor = myColors.red
            changeCategoryButton(to: buttonName)
        }
        default:
            break
        }
    }
    
    @IBAction func changeEntryType(_ sender: Any) {
        signIndex = signSegmentedControl.selectedSegmentIndex
        changeSelectedSegmentColor(to: signSegmentedControl.selectedSegmentIndex)
        changeTitleLabel(to: signSegmentedControl.selectedSegmentIndex)
    }
    
    @IBAction func saveCell(_ sender: Any) {
        let entry = Entry()
        
        func stringToCost(from str: String) -> Double{
            var resultString = ""
            for c in str {
                if c == " " { continue }
                resultString.append(c)
            }
            
            var result: Double = 0.0
            switch signSegmentedControl.selectedSegmentIndex{
            case 0: result = Double(resultString)!
            case 1: result = -Double(resultString)!
            default: break
            }
            return result
        }
        
        entry.name = nameTextField.text == "" ? "Новая запись" : nameTextField.text!
        entry.cost = stringToCost(from: costTextField.text == "" ? "0.0" : costTextField.text!)
        entry.date = datePicker.date
        entry.category = buttonName
        
        switch isNew {
        case true: delegate?.createCell(for: entry)
        case false: delegate?.updateCell(for: entry, at: cellIndex)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CategoryViewController, segue.identifier == "CategorySelection" {
            vc.delegate = self
            vc.choosingCategory = true
        }
    }
    
}

extension EntryDetailViewController: CategoryDelegate{
    func getCategory(from cat: String) {
        buttonName = cat
        changeCategoryButton(to: cat)
    }
}
