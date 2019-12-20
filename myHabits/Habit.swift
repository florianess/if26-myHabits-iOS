import CoreData

class Habit: NSManagedObject {
    static var all: [Habit] {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        guard let habits = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return habits
    }
    static var today: [Habit] {
        let habits = Habit.all
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday, .day, .month], from: date)
        let repetition = "\(components.weekday ?? 0)"
        let today = "\(components.day ?? 0)/\(components.month ?? 0)"
        return habits.filter({ (habit) -> Bool in
            return habit.repetition == "every" || habit.repetition == repetition || habit.repetition == today
        })
    }
    
    static func selectedHabits(cursor: Date) -> [Habit] {
        let habits = Habit.all
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday, .day, .month], from: cursor)
        let repetition = "\(components.weekday ?? 0)"
        let today = "\(components.day ?? 0)/\(components.month ?? 0)"
        return habits.filter({ (habit) -> Bool in
            return habit.repetition == "every" || habit.repetition == repetition || habit.repetition == today
        })
    }
}
