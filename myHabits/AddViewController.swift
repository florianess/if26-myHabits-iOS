//
//  AddViewController.swift
//  myHabits
//
//  Created by ESSLINGER Florian on 10/12/2019.
//  Copyright © 2019 ESSLINGER Florian. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var repetitionChoice: UISegmentedControl!
    @IBAction func addHabit(_ sender: UIButton) {
        let habit = Habit(context: AppDelegate.viewContext)
        habit.name = nameTextField.text
        habit.desc = descTextField.text
        habit.category = "\(Category.allCases[picker.selectedRow(inComponent: 0)])"
        habit.repetition = repetitionChoice.titleForSegment(at: repetitionChoice.selectedSegmentIndex)
        try? AppDelegate.viewContext.save()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.picker.delegate = self
        self.picker.dataSource = self
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

extension AddViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Category.allCases[row])"
    }
}
