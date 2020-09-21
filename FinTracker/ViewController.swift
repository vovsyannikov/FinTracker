//
//  ViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 14.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    static var shared = ViewController()
    
    private let realm = try! Realm()
    
    var entries: [Entry] = []
    var cellEntries: [Entry] = []
    @IBOutlet weak var entriesTableView: UITableView!
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    
    // MARK: Realm funcs
    // Запись в Realm
    func writeToRealm(from entry: Entry, at index: Int = -1){
        if index == -1{
            entries.append(entry)
        } else {
            entries.insert(entry, at: index)
        }
        
        try! self.realm.write {
            self.realm.add(entry)
        }
    }
    // Чтение из Realm
    func readFromRealm() -> [Entry]{
        var entries = [Entry]()
        
        for entry in self.realm.objects(Entry.self) {
            entries.append(entry)
        }
        
        return entries.sorted(by: { (first, second) -> Bool in
            first.date < second.date
        })
    }
    // Удаление из Realm
    func deleteFromRealm(_ entry: Entry){
        var entryToDelete: Int?
        for (index, el) in entries.enumerated() {
            if entry == el {
                entryToDelete = index
            }
        }
        
        if (entryToDelete != nil) {
            entries.remove(at: entryToDelete!)
        }
        
        try! realm.write {
            realm.delete(entry)
        }
    }
    // Обновление записи в Realm
    func updateRealm(entry: Entry, with newEntry: Entry) {
        deleteFromRealm(entry)
        writeToRealm(from: newEntry)
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Тестовая функция для записи
        func testInit(){
            entries.append(Entry())
            entries.append(Entry())
            
            entries[0].name = "Тестовое пополнение"
            entries[0].cost = 5_000.5
            entries[0].date = Date(timeIntervalSinceNow: 10800)
            entries[0].category = EntryType.income.rawValue
            
            entries[1].name = "Тестовая покупка"
            entries[1].cost = -5_000
            entries[1].date = Date(timeIntervalSince1970: 0)
            entries[1].category = EntryType.transport.rawValue
            
            writeToRealm(from: entries[0])
            writeToRealm(from: entries[1])
        }
        
//        testInit()
        entries = readFromRealm()
        sortEntries()
        cellEntries = entries
    }
    
    // MARK: prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? EntryTableViewCell, let index = entriesTableView.indexPath(for: cell){
            if let vc = segue.destination as? EntryDetailViewController, segue.identifier == SegueIDs.updateEntry.rawValue {
                vc.delegate = self
                
                let entry = entries[index.row]
                
                vc.isNew = false
                vc.signIndex = entry.isPositive() ? 0 : 1
                vc.cellIndex = index.row
                vc.name = entry.name
                vc.cost = costToString(from: entry.cost)
                vc.date = entry.date
                vc.color = cell.sumLabel.textColor
                vc.buttonName = entry.category
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
        entries.sort { (first, second) -> Bool in
            first.date < second.date
        }
    }
    
    //MARK: Entry sorting
    @IBAction func sortTableView(_ sender: Any) {
        
        let currentDay = MyDate(from: Date(timeIntervalSinceNow: 10800))
        cellEntries = []
        switch periodSegmentedControl.selectedSegmentIndex{
        case 0: cellEntries = entries
        case 1: do {
            for entry in entries {
                if entry.myDate.year == currentDay.year {
                    cellEntries.append(entry)
                }
            }
        }
        case 2: do {
            for entry in entries {
                if entry.myDate.year == currentDay.year && entry.myDate.month == currentDay.month {
                    cellEntries.append(entry)
                }
            }
        }
        case 3: do {
            for entry in entries {
                if entry.myDate.year == currentDay.year &&
                    entry.myDate.month == currentDay.month &&
                    currentDay.day - entry.myDate.day <= 7{
                    cellEntries.append(entry)
                }
            }
        }
        case 4: do {
            for entry in entries {
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
    func updateCell(for entry: Entry, at index: Int) {
        updateRealm(entry: entries[index], with: entry)
        sortEntries()
        entriesTableView.reloadData()
    }
    // Создание новой ячейки
    func createCell(for entry: Entry) {
        writeToRealm(from: entry)
        sortEntries()
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
        print(entry)
        
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
            
            deleteFromRealm(entries[indexPath.row])
            
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

