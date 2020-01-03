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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!
    var currentWeek: WeekHabits!
    var cursor = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)
        currentWeek = WeekHabits.selectWeek(cursor: cursor)
        
        pieChartView.animate(xAxisDuration: 1.0)
        pieChartView.animate(yAxisDuration: 1.0)
        barChartView.animate(yAxisDuration: 1.0, easingOption: ChartEasingOption.easeInOutSine)
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.dragEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        barChartView.leftAxis.granularity = 1
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.axisMinimum = 0
        displayWeek()
        customizeChart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        customizeChart()
    }
    
    func customizeChart() {
        let totalHabits = currentWeek.totalHabits?.reduce(0, +)
        let totalHabitsDone = currentWeek.habitsDone?.reduce(0, { (total, day) -> Double in
            let dayDone = day.split(separator: ",")
            return total + Double(dayDone.count)
            }
        )
        var dataEntries: [ChartDataEntry] = []
        totalLabel.text = "Total habitudes : \(Int(totalHabits!))"
        doneLabel.text = "Habitudes réalisées : \(Int(totalHabitsDone!))"
        dataEntries.append(PieChartDataEntry(value: totalHabitsDone!, label: "Habitudes réalisées"))
        dataEntries.append(PieChartDataEntry(value: totalHabits! - totalHabitsDone!, label: "Habitudes non réalisées"))
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        pieChartDataSet.colors = [UIColor(red: 0.00, green: 0.66, blue: 0.59, alpha: 1.0), UIColor(red: 0.11, green: 0.19, blue: 0.26, alpha: 1.0)]
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        pieChartView.data = pieChartData
        
        var dataEntriesBar: [BarChartDataEntry] = []
        for i in 0...currentWeek.habitsDone!.count-1 {
            let currentDay = currentWeek.habitsDone![i]
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(currentDay.split(separator: ",").count))
            dataEntriesBar.append(dataEntry)
        }
        let barChartDataSet = BarChartDataSet(entries: dataEntriesBar, label: "Habitudes réalisées par jour")
        barChartDataSet.colors = [UIColor(red: 0.00, green: 0.66, blue: 0.59, alpha: 1.0)]
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartData.setValueFormatter(formatter)
        barChartView.data = barChartData

        barChartView.xAxis.valueFormatter = CustomXAxis()
    }
    
    func displayWeek() {
        let components = DateComponents(weekOfYear: Int(currentWeek.weekNumber), yearForWeekOfYear: 2020)
        let date = Calendar.current.date(from: components)
        let date2 = Calendar.current.date(byAdding: .day, value: 6, to: date!)
        let df = DateFormatter()
        df.dateFormat = "dd/MM"
        weekLabel.text = "Semaine \(currentWeek.weekNumber)"
        dateLabel.text = "Du \(df.string(from: date!)) au \(df.string(from: date2!))"
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if (sender.direction == UISwipeGestureRecognizer.Direction.left) {
            cursor = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: cursor)!
        } else {
            cursor = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: cursor)!
        }
        currentWeek = WeekHabits.selectWeek(cursor: cursor)
        customizeChart()
        displayWeek()
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
