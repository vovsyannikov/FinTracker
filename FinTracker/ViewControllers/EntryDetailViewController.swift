//
//  EntryDetailViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 14.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit


//MARK: Entry Detail Delegate
protocol EntryDetailDelegate {
    func update(entry oldEntry: Entry, with newEntry: Entry)
    func createCell(for entry: Entry)
}

class EntryDetailViewController: UIViewController {
    
    var delegate: EntryDetailDelegate?
    
    var entry = Entry()
    var isNew = false
    var buttonName = "Выберете категорию"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var signSegmentedControl: UISegmentedControl!
    @IBOutlet weak var costTextField: UITextField!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if entry.type != .income {
            buttonName = entry.category
        }
        
        // Изменение заголовка карточки записи на Приход/Расход
        changeTitleLabel(to: entry.isPositive())
        
        // Изменение названия
        nameTextField.text = entry.name
        
        // Изменение знака Приход/Расход и стоимости
        signSegmentedControl.selectedSegmentIndex = entry.isPositive() ? 0 : 1
        changeSelectedSegmentColor(to: entry.isPositive())
        costTextField.text = entry.cost == 0.0 ? "" : entry.costString
        
        // Установка правильной русской локализации datePicker
        datePicker.locale = Locale(identifier: "ru")
        datePicker.date = entry.date.advanced(by: -10800)
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date(timeIntervalSinceNow: 10800)
        
        // Установка кнопки категории
        let textForCat = entry.category == "" ? buttonName : entry.category
        categoryButton.setAttributedTitle(underlinedText(from: "   \(textForCat)"), for: .normal)
        categoryButton.layer.borderWidth = 0.5
        categoryButton.layer.borderColor = UIColor.gray.cgColor
        categoryButton.layer.cornerRadius = 5
        
        changeSelectedSegmentColor(to: entry.isPositive())
    }
    
    //MARK: Mutating functions
    func underlinedText(from input: String) -> NSAttributedString {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        let resultingString = NSAttributedString(string: input, attributes: underlineAttribute)
        
        return resultingString
    }
    
    func fixedText(from input: String) -> NSAttributedString {
        let result: NSAttributedString = NSAttributedString(string: input)
        
        return result
    }
    
    func changeTitleLabel(to isPostive: Bool){
        switch isPostive {
        case true: self.titleLabel.text = "Приход"
        case false: self.titleLabel.text = "Расход"
        }
        
    }
    
    func changeCategoryButton(to cat: String) {
        let incomeString = "   \(EntryType.income.rawValue)"
        let outcomeString = cat == EntryType.other.rawValue || cat == EntryType.income.rawValue
            ? "   \(EntryType.other.rawValue)"
            : "   \(cat)"
        switch signSegmentedControl.selectedSegmentIndex {
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
    
    func changeSelectedSegmentColor(to isPositive: Bool){
        switch isPositive {
        case true: do{
            signSegmentedControl.selectedSegmentTintColor = myColors.green
            changeCategoryButton(to: EntryType.income.rawValue)
        }
        case false: do {
            signSegmentedControl.selectedSegmentTintColor = myColors.red
            changeCategoryButton(to: entry.category)
        }
        }
    }
    
    //MARK: action changeEntryType
    @IBAction func changeEntryType(_ sender: Any) {
        let signIndex = signSegmentedControl.selectedSegmentIndex == 0 ? true : false
        changeSelectedSegmentColor(to: signIndex)
        changeTitleLabel(to: signIndex)
        changeCategoryButton(to: entry.category == "" ? buttonName : entry.category)
    }
    
    //MARK: action saveCell
    @IBAction func saveCell(_ sender: Any) {
        let newEntry = Entry()
        
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
        func newEntryName() -> String {
            var emptyName = "Новая запись"
            var emptyNamesArchive: [String] = []
            for en in allEntries{
                if en.name == "Новая запись" {
                    emptyNamesArchive.append("\(emptyName) \(emptyNamesArchive.count)")
                }
            }
            if emptyNamesArchive.count > 0 {
                emptyName += " \(emptyNamesArchive.count+1)"
            }
            
            return emptyName
        }
        
        let stringAlert = UIAlertController(title: "Ошибка", message: "В поле стоимости присутствуют буквы", preferredStyle: .alert)
        stringAlert.addAction(UIAlertAction(title: "Исправить", style: .cancel, handler: nil))
        if (Double(costTextField.text!) == nil) {
            self.present(stringAlert, animated: true, completion: nil)
        } else {
            newEntry.name = nameTextField.text == "" ? newEntryName() : nameTextField.text!
            newEntry.cost = stringToCost(from: costTextField.text == "" ? "0.0" : costTextField.text!)
            newEntry.date = datePicker.date
            newEntry.category = signSegmentedControl.selectedSegmentIndex == 0 ? EntryType.income.rawValue : buttonName
            
            switch isNew {
            case true: delegate?.createCell(for: newEntry)
            case false: delegate?.update(entry: entry, with: newEntry)
            }
            
            createEntryData(for: newEntry)
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: prepare(for segue)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CategoryViewController, segue.identifier == SegueIDs.selectCategory.rawValue {
            vc.delegate = self
            vc.choosingCategory = true
        }
    }
    
}

//MARK: ext CategoryDelegate
extension EntryDetailViewController: CategoryDelegate{
    func getCategory(from cat: String) {
        buttonName = cat
        changeCategoryButton(to: cat)
    }
}

extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            textField.resignFirstResponder()
            costTextField.becomeFirstResponder()
            
        case costTextField:
            textField.resignFirstResponder()
            
        default: break
        }
        
        return true
    }
}
