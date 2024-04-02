//
//  MealManager.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 18/03/2024.
//

import UIKit
import CoreData

class MealManager {
    static let shared = MealManager()

    private init() {}

    func fetchOrCreateMeal(name mealName: String, date: Date) -> Meal? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let dateOnly = calendar.date(from: components) else { return nil }
        
        fetchRequest.predicate = NSPredicate(format: "type == %@ AND date == %@", mealName, dateOnly as NSDate)
        fetchRequest.fetchLimit = 1
        
        do {
            if let existingMeal = try managedContext.fetch(fetchRequest).first {
                return existingMeal
            } else {
                let newMeal = Meal(context: managedContext)
                newMeal.type = mealName
                newMeal.date = dateOnly
                
                try managedContext.save()
                return newMeal
            }
        } catch let error as NSError {
            print("Could not fetch or create a new meal: \(error), \(error.userInfo)")
            return nil
        }
    }
}
