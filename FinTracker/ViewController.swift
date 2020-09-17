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
    
    private let realm = try! Realm()
    
    var entries = [Entry]()
    let colors: (green: UIColor, red: UIColor) = (green: UIColor(red: 0, green: 0.5, blue: 0, alpha: 1), red: UIColor.red)
    @IBOutlet weak var entriesTableView: UITableView!
    
    // MARK: Realm funcs
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
    func readFromRealm() -> [Entry]{
        var entries = [Entry]()
        
        for entry in self.realm.objects(Entry.self) {
            entries.append(entry)
        }
        
        return entries.sorted(by: { (first, second) -> Bool in
            first.date < second.date
        })
    }
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
    func updateRealm(entry: Entry, with newEntry: Entry) {
        deleteFromRealm(entry)
        writeToRealm(from: newEntry)
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func testInit(){
            entries.append(Entry())
            entries.append(Entry())

            entries[0].name = "Тестовое пополнение"
            entries[0].cost = 5_000.5
            entries[0].date = Date(timeIntervalSinceNow: 10800)


            entries[1].name = "Тестовая покупка"
            entries[1].cost = -5_000
            entries[1].date = Date(timeIntervalSince1970: 0)
            
            writeToRealm(from: entries[0])
            writeToRealm(from: entries[1])
        }
        
//        testInit()
        entries = readFromRealm()
        print(entries)
    }
    
    // MARK: prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? EntryTableViewCell, let index = entriesTableView.indexPath(for: cell){
            if let vc = segue.destination as? EntryDetailViewController, segue.identifier == "EntryDetail" {
                vc.delegate = self
                
                let entry = entries[index.row]
                
                vc.isNew = false
                vc.signIndex = entry.isPositive() ? 0 : 1
                vc.cellIndex = index.row
                vc.name = entry.name
                vc.cost = costToString(from: entry.cost)
                vc.date = entry.date
                vc.color = cell.sumLabel.textColor
            }
        }
        if let vc = segue.destination as? EntryDetailViewController, segue.identifier == "CreateEntry" {
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

}

// MARK: EntryDetailDelegate
extension ViewController: EntryDetailDelegate {
    // Обновление имеющихся ячеек
    func updateCell(for entry: Entry, at index: Int) {
        updateRealm(entry: entries[index], with: entry)
        entriesTableView.reloadData()
    }
    // Создание новой ячейки
    func createCell(for entry: Entry) {
        writeToRealm(from: entry)
        entriesTableView.reloadData()
    }
}

// MARK: TODO - Sections
extension ViewController: UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        var numOfSections = 0
//        var foundSections: [String] = []
//
//        for entry in entries {
//            let formattedDateString = entry.formattedDate()
//            if !foundSections.contains(formattedDateString) {
//                numOfSections += 1
//                foundSections.append(formattedDateString)
//            }
//        }
//        return numOfSections
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return entries[section].formattedDate()
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var count = 0
//        var foundEntries: [String] = []
//
//        for entry in entries {
//            let formattedDateString = "\(entry.formattedDate().day)/\(entry.formattedDate().month)/\(entry.formattedDate().year)"
//            if !foundEntries.contains(formattedDateString){
//                count += 1
//                foundEntries.append(formattedDateString)
//            }
//        }

        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Entry") as! EntryTableViewCell
        
        let entry = entries[indexPath.row]
        print(entry)
        
        cell.nameLabel.text = entry.name
        cell.sumLabel.text = costToString(from: entry.cost) + " ₽"
        
        switch entry.type {
        case .income: do {
            cell.signImageView.image = UIImage(systemName: "plus.circle")
            cell.signImageView.tintColor = colors.green
            cell.sumLabel.textColor = colors.green
            }
        case .outcome: do {
            cell.signImageView.image = UIImage(systemName: "minus.circle")
            cell.signImageView.tintColor = colors.red
            cell.sumLabel.textColor = colors.red
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            
            deleteFromRealm(entries[indexPath.row])
            
            self.entriesTableView.beginUpdates()
            self.entriesTableView.deleteRows(at: [indexPath], with: .automatic)
            self.entriesTableView.endUpdates()
            
            self.entriesTableView.reloadData()
        }
    }
    
}

