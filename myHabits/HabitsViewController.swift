//
//  HabitsViewController.swift
//  myHabits
//
//  Created by ESSLINGER Florian on 11/12/2019.
//  Copyright © 2019 ESSLINGER Florian. All rights reserved.
//

import UIKit

class HabitTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var categorieLabel: UILabel!
    @IBOutlet weak var repetitionLabel: UILabel!
    @IBOutlet weak var doneSwitch: UISwitch!
    @IBAction func onSwitch(_ sender: UISwitch) {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        let todayHabitsDoneStr = WeekHabits.currentWeek.habitsDone?[components.weekday! - 1]
        var todayHabitsDone = todayHabitsDoneStr?.components(separatedBy: ",")
        if ((todayHabitsDone?.contains(titleLabel.text ?? "w") ?? false) && !sender.isOn) {
            let updateHabitsDone = todayHabitsDone?.filter({ (habitName) -> Bool in
                habitName != titleLabel.text
            });
            WeekHabits.currentWeek.habitsDone?[components.weekday! - 1] = updateHabitsDone?.joined(separator: ",") ?? ""
        } else {
            todayHabitsDone?.append(titleLabel?.text ?? "")
            WeekHabits.currentWeek.habitsDone?[components.weekday! - 1] = todayHabitsDone?.joined(separator: ",") ?? ""
        }
        try? AppDelegate.viewContext.save()
    }
    
}

class HabitsViewController: UITableViewController {
    
    var categoriesColor: [String : UIColor] = [
        "Sport": UIColor(red: CGFloat(0.8), green: CGFloat(0.9), blue: CGFloat(0.8), alpha: CGFloat(1)),
        "Relaxation": UIColor(red: CGFloat(0.1), green: CGFloat(0.9), blue: CGFloat(0.8), alpha: CGFloat(1)),
        "Cours": UIColor(red: CGFloat(0.1), green: CGFloat(0.4), blue: CGFloat(0.8), alpha: CGFloat(1)),
        "Rangement": UIColor(red: CGFloat(0.5), green: CGFloat(0.9), blue: CGFloat(0.8), alpha: CGFloat(1)),
    ]
    
    var habits: [Habit] = Habit.selectedHabits(cursor: Date())
    var cursor = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if (sender.direction == UISwipeGestureRecognizer.Direction.left) {
            cursor = Calendar.current.date(byAdding: .day, value: 1, to: cursor)!
        } else {
            cursor = Calendar.current.date(byAdding: .day, value: -1, to: cursor)!
        }
        habits = Habit.selectedHabits(cursor: cursor)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        self.tableView.reloadData()
    
    self.navigationItem.title = formatter.string(from: cursor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        habits = Habit.selectedHabits(cursor: Date())
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as! HabitTableViewCell
        let habit = habits[indexPath.row]
        cell.titleLabel?.text = habit.name
        cell.descLabel?.text = habit.desc
        cell.categorieLabel?.text = habit.category
        cell.repetitionLabel?.text = habit.repetitionLabel
        cell.backgroundColor = categoriesColor[habit.category ?? ""]
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        let todayHabitsDoneStr = WeekHabits.currentWeek.habitsDone?[components.weekday! - 1]
        let todayHabitsDone = todayHabitsDoneStr?.components(separatedBy: ",")
        if (todayHabitsDone?.contains(habit.name ?? "w") ?? false) {
            cell.doneSwitch.setOn(true, animated: false)
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
