//
//  ViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 14.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var entries = [Entry]()
    let colors: (green: UIColor, red: UIColor) = (green: UIColor(red: 0, green: 0.5, blue: 0, alpha: 1), red: UIColor.red)
    @IBOutlet weak var entriesTableView: UITableView!
    
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
        }
        
        testInit()
        
    }
    
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

extension ViewController: EntryDetailDelegate {
    // Обновление имеющихся ячеек
    func updateCell(for entry: Entry, at index: Int) {
        entries[index] = entry
        entriesTableView.reloadData()
    }
    // Создание новой ячейки
    func createCell(for entry: Entry) {
        entries.append(entry)
        entriesTableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Entry") as! EntryTableViewCell
        
        let entry = entries[indexPath.row]
        
        cell.nameLabel.text = entry.name
        cell.sumLabel.text = costToString(from: entry.cost)
        
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
            var entryIndexToDelete: Int?
            for (index, _) in entries.enumerated() {
                if index == indexPath.row {
                    entryIndexToDelete = index
                }
            }
            
            entries.remove(at: entryIndexToDelete!)
            
            self.entriesTableView.beginUpdates()
            self.entriesTableView.deleteRows(at: [indexPath], with: .automatic)
            self.entriesTableView.endUpdates()
            
            self.entriesTableView.reloadData()
        }
    }
    
}

