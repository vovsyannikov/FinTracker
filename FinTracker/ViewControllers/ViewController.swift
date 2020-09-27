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
            }
        }
        if let vc = segue.destination as? EntryDetailViewController, segue.identifier == SegueIDs.createEntry.rawValue {
            vc.delegate = self
            vc.isNew = true
        }
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
        
        deleteEntryData(oldEntry)
        createEntryData(for: newEntry)
        
        cellEntries = allEntries
        sortEntries()
        
        entriesTableView.reloadData()
    }
    // Создание новой ячейки
    func createCell(for entry: Entry) {
        createEntryData(for: entry)
        
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

