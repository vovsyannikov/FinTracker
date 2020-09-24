//
//  CategoryDetailViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 21.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit
import Charts

class CategoryDetailViewController: UIViewController {
    
    var currentCategory = MyCategory()
    var applicableEntries: [Entry] = []
    let lineChart = LineChartView()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var sortingSegControl: UISegmentedControl!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateChart()
    }
    
    func updateChart(){
        lineChart.frame = CGRect(x: 0, y: 200, width: self.view.bounds.width, height: self.view.bounds.height / 3)
        
        var lineChartEntries = [ChartDataEntry]()
        for (index, en) in applicableEntries.enumerated() {
            lineChartEntries.append(ChartDataEntry(
                                        x: Double(index),
                                        y: en.isPositive() ? en.cost : -en.cost)
            )
        }
        let lineChartDataSet = LineChartDataSet(entries: lineChartEntries,
                                             label: currentCategory.name)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChart.data = lineChartData
        
        view.addSubview(lineChart)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for entry in allEntries{
            if entry.category == currentCategory.name {
                applicableEntries.append(entry)
            }
        }
        titleLabel.text = currentCategory.name
    }
    

}

extension CategoryDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applicableEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryEntry") as! EntryTableViewCell
        
        let currentEntry = applicableEntries[indexPath.row]
        cell.nameLabel.text = currentEntry.name
        cell.dateLabel.text = currentEntry.myDate.getDate()
        cell.costLabel.text = currentEntry.costString
        cell.setSignImageView(with: currentEntry.type)
        
        return cell
    }
    
    
}
