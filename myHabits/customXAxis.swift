//
//  customXAxis.swift
//  myHabits
//
//  Created by Thibault Esslinger on 02/01/2020.
//  Copyright © 2020 ESSLINGER Florian. All rights reserved.
//

import Foundation
import Charts

class CustomXAxis: IAxisValueFormatter {
    let weekDays = ["Dim","Lun","Mar","Mer","Jeu","Ven","Sam"]
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return weekDays[Int(value)]
    }
}
