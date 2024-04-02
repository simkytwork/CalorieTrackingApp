//
//  Meal+CoreDataProperties.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 16/02/2024.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var type: String?
    public var wrappedType: String {
        type ?? "Unknown type"
    }
    @NSManaged public var date: Date?
    @NSManaged public var kcal: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
    @NSManaged public var protein: Double
    @NSManaged public var foodentry: NSSet?
    public var foodEntryArray: [FoodEntry] {
        let set = foodentry as? Set<FoodEntry> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }

}

// MARK: Generated accessors for foodentry
extension Meal {

    @objc(addFoodentryObject:)
    @NSManaged public func addToFoodentry(_ value: FoodEntry)

    @objc(removeFoodentryObject:)
    @NSManaged public func removeFromFoodentry(_ value: FoodEntry)

    @objc(addFoodentry:)
    @NSManaged public func addToFoodentry(_ values: NSSet)

    @objc(removeFoodentry:)
    @NSManaged public func removeFromFoodentry(_ values: NSSet)

}

extension Meal : Identifiable {

}
