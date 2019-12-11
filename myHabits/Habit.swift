import CoreData

class Habit: NSManagedObject {
    static var all: [Habit] {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        guard let habits = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return habits
    }
}
