//
//  CustomMeal+CoreDataProperties.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 12/03/2024.
//
//

import Foundation
import CoreData


extension CustomMeal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomMeal> {
        return NSFetchRequest<CustomMeal>(entityName: "CustomMeal")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    public var wrappedName: String {
        name ?? "Unknown name"
    }
    @NSManaged public var kcal: Double
    @NSManaged public var fat: Double
    @NSManaged public var protein: Double
    @NSManaged public var carbs: Double
    @NSManaged public var size: Double
    @NSManaged public var wasDeleted: Bool
    @NSManaged public var custommealentry: NSSet?
    public var customMealEntryArray: [CustomMealEntry] {
        let set = custommealentry as? Set<CustomMealEntry> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
    @NSManaged public var foodentry: NSSet?
    public var foodEntryArray: [FoodEntry] {
        let set = foodentry as? Set<FoodEntry> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }

}

// MARK: Generated accessors for custommealentry
extension CustomMeal {

    @objc(addCustommealentryObject:)
    @NSManaged public func addToCustommealentry(_ value: CustomMealEntry)

    @objc(removeCustommealentryObject:)
    @NSManaged public func removeFromCustommealentry(_ value: CustomMealEntry)

    @objc(addCustommealentry:)
    @NSManaged public func addToCustommealentry(_ values: NSSet)

    @objc(removeCustommealentry:)
    @NSManaged public func removeFromCustommealentry(_ values: NSSet)

}

// MARK: Generated accessors for foodentry
extension CustomMeal {

    @objc(addFoodentryObject:)
    @NSManaged public func addToFoodentry(_ value: FoodEntry)

    @objc(removeFoodentryObject:)
    @NSManaged public func removeFromFoodentry(_ value: FoodEntry)

    @objc(addFoodentry:)
    @NSManaged public func addToFoodentry(_ values: NSSet)

    @objc(removeFoodentry:)
    @NSManaged public func removeFromFoodentry(_ values: NSSet)

}

extension CustomMeal : Identifiable {

}
