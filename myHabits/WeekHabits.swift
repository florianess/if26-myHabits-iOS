import CoreData

class WeekHabits: NSManagedObject {
    
    static var all: [WeekHabits] {
        let request: NSFetchRequest<WeekHabits> = WeekHabits.fetchRequest()
        guard let weekHabits = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return weekHabits
    }
    
    static func selectWeek(cursor: Date) -> WeekHabits {
        let allWeekHabits = WeekHabits.all
        print(allWeekHabits)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear], from: cursor)
        let weekNumber = Int16(components.weekOfYear ?? 0)
        let select = allWeekHabits.filter({ (week) -> Bool in
            return week.weekNumber == weekNumber
        })
        if (select.count == 1) {
            print(select[0])
            return select[0]
        } else {
            let currentWeekHabits = WeekHabits(context: AppDelegate.viewContext)
            let allHabits = Habit.all
            let everyHabits = allHabits.reduce(0, { (total, habit) -> Double in
                if (habit.repetition == "every") {
                    return total + Double(1)
                }
                return total
                }
            )
            currentWeekHabits.weekNumber = weekNumber
            currentWeekHabits.totalHabits = []
            currentWeekHabits.habitsDone = []
            for _ in 1...7 {
                currentWeekHabits.totalHabits?.append(everyHabits)
                currentWeekHabits.habitsDone?.append("")
            }
            
            try? AppDelegate.viewContext.save()
            return currentWeekHabits
        }
    }
}
