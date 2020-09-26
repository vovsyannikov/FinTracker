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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        entriesTableView.reloadData()
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entriesTableView.reloadData()
        
        // Тестовая функция для записи
        func testInit(){
            allEntries.append(Entry())
            allEntries.append(Entry())
            allEntries.append(Entry())
            allEntries.append(Entry())
            
            allEntries[0].name = "Тестовое пополнение"
            allEntries[0].cost = 5_000.5
            allEntries[0].date = Date(timeIntervalSinceNow: 0)
            allEntries[0].category = EntryType.income.rawValue
            
            allEntries[1].name = "Тестовая покупка"
            allEntries[1].cost = -5_000
            allEntries[1].date = Date(timeIntervalSinceNow: -152153223)
            allEntries[1].category = EntryType.transport.rawValue
            
            allEntries[2].name = "Тестовая покупка 2"
            allEntries[2].cost = -12_020
            allEntries[2].date = Date(timeIntervalSinceNow: -212412)
            allEntries[2].category = EntryType.transport.rawValue
            
            allEntries[3].name = "Тестовая покупка 3"
            allEntries[3].cost = -7_500
            allEntries[3].date = Date(timeIntervalSinceNow: -10591251)
            allEntries[3].category = EntryType.house.rawValue
        }
        
//        testInit()
        retrieveEntryData()
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
        switch periodSegmentedControl.selectedSegmentIndex {
        case 0: cellEntries = dateSort(allEntries, by: .all)
        case 1: cellEntries = dateSort(allEntries, by: .year)
        case 2: cellEntries = dateSort(allEntries, by: .month)
        case 3: cellEntries = dateSort(allEntries, by: .week)
        case 4: cellEntries = dateSort(allEntries, by: .day)
        default: break
        }
        sortEntries()
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
        cellEntries = allEntries
        sortEntries()
        
        entriesTableView.reloadData()
    }
    // Создание новой ячейки
    func createCell(for entry: Entry) {
        allEntries.append(entry)
        cellEntries = allEntries
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
        
        cell.nameLabel.text = entry.name
        cell.costLabel.text = costToString(from: entry.cost) + " ₽"
        cell.dateLabel.text = entry.myDate.getDate()
        cell.setSignImageView(with: entry.type)
        
        return cell
    }
    
    // MARK: Editing style (deleting rows)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            
            let entryToDelete = cellEntries[indexPath.row]
            deleteEntryData(entryToDelete)
            cellEntries.remove(at: indexPath.row)
            
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

