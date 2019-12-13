//
//  StatsViewController.swift
//  myHabits
//
//  Created by ESSLINGER Florian on 13/12/2019.
//  Copyright © 2019 ESSLINGER Florian. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet weak var weekLabel: UILabel!
    var currentWeek: WeekHabits!
    override func viewDidLoad() {
        super.viewDidLoad()
        currentWeek = WeekHabits.currentWeek
        weekLabel.text = "Semaine \(currentWeek.weekNumber)"
        // Do any additional setup after loading the view.
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
