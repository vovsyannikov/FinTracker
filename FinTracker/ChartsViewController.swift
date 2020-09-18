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

    var entries: [Entry] = []
    
    let pieChart = PieChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        entries = ViewController.shared.readFromRealm()
        updateChart()
    }
    
    func updateChart(){
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        pieChart.center = view.center
        view.addSubview(pieChart)
        
        var pieChartEntries = [ChartDataEntry]()
        var incomeSum = 0.0
        var outcomeSum = 0.0
        for entry in entries {
            switch entry.isPositive() {
            case true:
                incomeSum += entry.cost
            case false:
                outcomeSum += -entry.cost
            }
        }
        pieChartEntries.append(ChartDataEntry(x: incomeSum, y: incomeSum))
        pieChartEntries.append(ChartDataEntry(x: outcomeSum, y: outcomeSum))
        
        let setOfEntries = PieChartDataSet(entries: pieChartEntries, label: "+/-")
        setOfEntries.colors = [
            myColors.green,
            myColors.red
        ]
        let data = PieChartData(dataSet: setOfEntries)
        pieChart.data = data
    }
    

}
