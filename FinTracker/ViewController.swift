//
//  ViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 14.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    static var shared = ViewController()
    
    var cellEntries: [Entry] = []
    var sentEntry = Entry()
    @IBOutlet weak var entriesTableView: UITableView!
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    
      
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entriesTableView.reloadData()
        
        // Тестовая функция для записи
        func testInit(){
            allEntries.append(Entry())
            allEntries.append(Entry())
            
            allEntries[0].name = "Тестовое пополнение"
            allEntries[0].cost = 5_000.5
            allEntries[0].date = Date(timeIntervalSinceNow: 10800)
            allEntries[0].category = EntryType.income.rawValue
            
            allEntries[1].name = "Тестовая покупка"
            allEntries[1].cost = -5_000
            allEntries[1].date = Date(timeIntervalSince1970: 0)
            allEntries[1].category = EntryType.transport.rawValue
        }
        
//        testInit()
        cellEntries = allEntries
        sortEntries()
    }
    
    // MARK: prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? EntryTableViewCell, let index = entriesTableView.indexPath(for: cell){
            if let vc = segue.destination as? EntryDetailViewController, segue.identifier == SegueIDs.updateEntry.rawValue {
                vc.delegate = self
                
                let entry = cellEntries[index.row]
                
                vc.isNew = false
                vc.entry = entry
                sentEntry.name = entry.name
                sentEntry.cost = entry.cost
                sentEntry.category = entry.category
                sentEntry.date = entry.date
            }
        }
        if let vc = segue.destination as? EntryDetailViewController, segue.identifier == SegueIDs.createEntry.rawValue {
            vc.delegate = self
            vc.isNew = true
        }
    }
    
    // Функция преобразования числа в строку
    func costToString(from cost: Double) -> String{
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        
        let costNumber = NSNumber(value: cost >= 0 ? cost : -cost)
        let result = formatter.string(from: costNumber)
        
        return result!
    }
    
    func sortEntries(){
        cellEntries.sort { (first, second) -> Bool in
            first.date < second.date
        }
    }
    
    //MARK: Entry sorting
    @IBAction func sortTableView(_ sender: Any) {
        
        let currentDay = MyDate(from: Date(timeIntervalSinceNow: 10800))
        cellEntries = []
        switch periodSegmentedControl.selectedSegmentIndex{
        case 0: cellEntries = allEntries
        case 1: do {
            for entry in allEntries {
                if entry.myDate.year == currentDay.year {
                    cellEntries.append(entry)
                }
            }
        }
        case 2: do {
            for entry in allEntries {
                if entry.myDate.year == currentDay.year && entry.myDate.month == currentDay.month {
                    cellEntries.append(entry)
                }
            }
        }
        case 3: do {
            for entry in allEntries {
                if entry.myDate.year == currentDay.year &&
                    entry.myDate.month == currentDay.month &&
                    currentDay.day - entry.myDate.day <= 7{
                    cellEntries.append(entry)
                }
            }
        }
        case 4: do {
            for entry in allEntries {
                if entry.myDate.year == currentDay.year &&
                    entry.myDate.month == currentDay.month &&
                    entry.myDate.day == currentDay.day{
                    cellEntries.append(entry)
                }
            }
        }
        default: break
        }
        entriesTableView.reloadData()
    }
}

// MARK: ext EntryDetailDelegate
extension ViewController: EntryDetailDelegate {
    // Обновление имеющихся ячеек
    func update(entry oldEntry: Entry, with newEntry: Entry) {
        var indexToReplace = 15
        for (index, el) in allEntries.enumerated(){
            if oldEntry == el {
                indexToReplace = index
            }
        }
        allEntries.remove(at: indexToReplace)
        allEntries.insert(newEntry, at: indexToReplace)
        
        entriesTableView.reloadData()
    }
    // Создание новой ячейки
    func createCell(for entry: Entry) {
        allEntries.append(entry)
        entriesTableView.reloadData()
    }
}

// MARK: ext TableView
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    //MARK: Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellEntries.count
    }
    
    //MARK: Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Entry") as! EntryTableViewCell
        
        let entry = cellEntries[indexPath.row]
        
        cell.nameLabel.text = entry.name
        cell.sumLabel.text = costToString(from: entry.cost) + " ₽"
        cell.dateLabel.text = entry.myDate.getDate()
        
        switch entry.type {
        case .income: do {
            cell.signImageView.image = UIImage(systemName: "plus.circle")
            cell.signImageView.tintColor = myColors.green
            cell.sumLabel.textColor = myColors.green
        }
        case .outcome: do {
            cell.signImageView.image = UIImage(systemName: "minus.circle")
            cell.signImageView.tintColor = myColors.red
            cell.sumLabel.textColor = myColors.red
        }
        default: break
        }
        
        return cell
    }
    
    // MARK: Editing style (deleting rows)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            
            
            self.entriesTableView.beginUpdates()
            self.entriesTableView.deleteRows(at: [indexPath], with: .automatic)
            self.entriesTableView.endUpdates()
            
            self.entriesTableView.reloadData()
        }
    }
    
    // MARK: Did select row at
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

