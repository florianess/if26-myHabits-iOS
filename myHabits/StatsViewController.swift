//
//  StatsViewController.swift
//  myHabits
//
//  Created by ESSLINGER Florian on 13/12/2019.
//  Copyright © 2019 ESSLINGER Florian. All rights reserved.
//

import UIKit
import Charts

class StatsViewController: UIViewController {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    var currentWeek: WeekHabits!
    override func viewDidLoad() {
        super.viewDidLoad()
        currentWeek = WeekHabits.selectWeek(cursor: Date())
        weekLabel.text = "Semaine \(currentWeek.weekNumber)"
        
        customizeChart()
        // Do any additional setup after loading the view.
    }
    
    func customizeChart() {
        let totalHabits = currentWeek.totalHabits?.reduce(0, +)
        let totalHabitsDone = currentWeek.habitsDone?.reduce(0, { (total, day) -> Double in
            let dayDone = day.split(separator: ",")
            return total + Double(dayDone.count)
            }
        )
        var dataEntries: [ChartDataEntry] = []
        dataEntries.append(PieChartDataEntry(value: totalHabitsDone!, label: "Habitudes réalisées", data: "Habitudes réalisées" as Any))
        dataEntries.append(PieChartDataEntry(value: totalHabits! - totalHabitsDone!, label: "Habitudes non réalisées", data: "Habitudes non réalisées" as Any))
        let pieChartDataSet = PieChartDataSet(entries: dataEntries)
        pieChartDataSet.colors = [.blue, .green]
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        pieChartView.data = pieChartData
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
