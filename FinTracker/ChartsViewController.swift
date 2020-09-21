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
    
    let pieChart = PieChartView()
    
    // MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: View did appear
    override func viewDidAppear(_ animated: Bool) {
        updateChart()
    }
    
    //MARK: Update chart
    func updateChart(){
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        pieChart.center = view.center
        view.addSubview(pieChart)
        
        var pieChartEntries = [PieChartDataEntry]()
        var incomeSum = 0.0
        var outcomeSum = 0.0
        for entry in allEntries {
            switch entry.isPositive() {
            case true:
                incomeSum += entry.cost
            case false:
                outcomeSum += -entry.cost
            }
        }
        pieChartEntries.append(PieChartDataEntry(value: incomeSum, label: EntryType.income.rawValue))
        pieChartEntries.append(PieChartDataEntry(value: outcomeSum, label: EntryType.outcome.rawValue))
        
        let setOfEntries = PieChartDataSet(entries: pieChartEntries, label: "")
        setOfEntries.colors = [
            myColors.green,
            myColors.red
        ]
        let data = PieChartData(dataSet: setOfEntries)
        pieChart.data = data
    }
    
    
}
