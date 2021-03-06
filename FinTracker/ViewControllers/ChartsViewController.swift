//
//  ChartsViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 17.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var chartView: UIView!
    let pieChart = PieChartView()
    
    // MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: View did appear
    override func viewDidAppear(_ animated: Bool) {
        updateBalance()
        updateChart()
    }
    
    func updateBalance(){
        var balance = 0.0
        for en in allEntries {
            balance += en.cost
        }
        
        balanceLabel.text = costToString(from: balance) + " ₽"
        balanceLabel.textColor = balance >= 0 ? myColors.green : myColors.red
    }
    
    //MARK: Update chart
    func updateChart(){
        func initPieEntries() -> [PieChartDataEntry] {
            var result: [PieChartDataEntry] = []
            var categorizedEntries: Dictionary<String, Double> = [:]
            
            for entry in allEntries {
                if categorizedEntries[entry.category] == nil {
                    categorizedEntries[entry.category] = 0.0
                }
                categorizedEntries[entry.category]! += entry.isPositive() ? entry.cost : -entry.cost
            }
            
            let incomeEntry = PieChartDataEntry(
                value: categorizedEntries[EntryType.income.rawValue] == nil ? 0.0 : categorizedEntries[EntryType.income.rawValue]!,
                label: EntryType.income.rawValue)

            result.append(incomeEntry)
            
            for (name, cost) in categorizedEntries {
                if name == EntryType.income.rawValue {
                    continue
                }
                result.append(PieChartDataEntry(value: cost, label: name))
            }
            
            return result
        }
        
        pieChart.frame = chartView.frame
        view.addSubview(pieChart)
        
        let pieChartEntries = allEntries.isEmpty ? [PieChartDataEntry]() : initPieEntries()
        
        let setOfEntries = PieChartDataSet(entries: pieChartEntries, label: "")
        setOfEntries.colors = [
            myColors.green,
            UIColor(red: 217/255.0, green: 80/255.0, blue: 138/255.0, alpha: 1.0),
            UIColor(red: 254/255.0, green: 149/255.0, blue: 7/255.0, alpha: 1.0),
            UIColor(red: 254/255.0, green: 247/255.0, blue: 120/255.0, alpha: 1.0),
            UIColor(red: 106/255.0, green: 167/255.0, blue: 134/255.0, alpha: 1.0),
            UIColor(red: 53/255.0, green: 194/255.0, blue: 209/255.0, alpha: 1.0)
        ]
        let data = PieChartData(dataSet: setOfEntries)
        pieChart.data = data
        
        
    }
    
    
}
