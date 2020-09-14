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
        entries.append(Entry())
        entries.append(Entry())
        
        entries[0].name = "Тестовое пополнение"
        entries[0].cost = 5_000
        entries[0].date = Date(timeIntervalSinceNow: 10800)
        
        entries[1].name = "Тестовая покупка"
        entries[1].cost = -5_000
        entries[1].date = Date(timeIntervalSinceNow: 10800)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? EntryTableViewCell, let _ = entriesTableView.indexPath(for: cell){
            if let vc = segue.destination as? EntryDetailViewController, segue.identifier == "EntryDetail" {
                vc.cost = cell.sumLabel.text!
                vc.name = cell.nameLabel.text!
                vc.sign = cell.signImageView.image!
                vc.color = cell.sumLabel.textColor
            }
        }
    }

}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Entry") as! EntryTableViewCell
        
        func isPositive(for num: Double) -> Bool {
            return num >= 0
        }
        
        
        
        let entry = entries[indexPath.row]
        
        cell.nameLabel.text = entry.name
        cell.sumLabel.text = entry.costToString()
        
        switch isPositive(for: entry.cost) {
        case true: do {
            cell.signImageView.image = UIImage(systemName: "plus.circle")
            cell.signImageView.tintColor = colors.green
            cell.sumLabel.textColor = colors.green
            }
        case false: do {
            cell.signImageView.image = UIImage(systemName: "minus.circle")
            cell.signImageView.tintColor = colors.red
            cell.sumLabel.textColor = colors.red
            }
        }
        
        return cell
    }
    
}

