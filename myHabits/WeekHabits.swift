import CoreData

class WeekHabits: NSManagedObject {
    
    static var all: [WeekHabits] {
        let request: NSFetchRequest<WeekHabits> = WeekHabits.fetchRequest()
        guard let weekHabits = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return weekHabits
    }
    static var currentWeek: WeekHabits {
        let allWeekHabits = WeekHabits.all
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear], from: date)
        let weekNumber: Int16 = Int16(components.weekOfYear ?? 0)
        let current = allWeekHabits.filter({ (week) -> Bool in
            return week.weekNumber == weekNumber
        })
        if (current.count == 1) {
            print(current[0])
            return current[0]
        } else {
            let currentWeekHabits = WeekHabits(context: AppDelegate.viewContext)
            currentWeekHabits.weekNumber = weekNumber
            currentWeekHabits.totalHabits = [0,0,0,0,0,0,0]
            currentWeekHabits.habitsDone = ["","","","","","",""]
            try? AppDelegate.viewContext.save()
            return currentWeekHabits
        }
    }
}
