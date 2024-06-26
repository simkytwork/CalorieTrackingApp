//
//  Food+CoreDataProperties.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 16/02/2024.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var name: String?
    public var wrappedName: String {
        name ?? "Unknown name"
    }
    
    @NSManaged public var brand: String?
    public var wrappedBrand: String {
        brand ?? "Unknown brand"
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var category: String?
    public var wrappedCategory: String {
        category ?? "Unknown category"
    }
    
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
    @NSManaged public var kcal: Double
    @NSManaged public var perserving: String?
    public var wrappedPerServing: String {
        perserving ?? "Unknown serving content"
    }
    @NSManaged public var protein: Double
    @NSManaged public var serving: String?
    public var wrappedServing: String {
        serving ?? "Unknown serving"
    }
    @NSManaged public var size: Double
    
    @NSManaged public var wasDeleted: Bool
    @NSManaged public var isFromDatabase: Bool
    
    @NSManaged public var foodentry: NSSet?
    public var foodEntryArray: [FoodEntry] {
        let set = foodentry as? Set<FoodEntry> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
    
    @NSManaged public var custommealentry: NSSet?
    public var customMealEntryArray: [CustomMealEntry] {
        let set = custommealentry as? Set<CustomMealEntry> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
}

// MARK: Generated accessors for foodentry
extension Food {

    @objc(addFoodentryObject:)
    @NSManaged public func addToFoodentry(_ value: FoodEntry)

    @objc(removeFoodentryObject:)
    @NSManaged public func removeFromFoodentry(_ value: FoodEntry)

    @objc(addFoodentry:)
    @NSManaged public func addToFoodentry(_ values: NSSet)

    @objc(removeFoodentry:)
    @NSManaged public func removeFromFoodentry(_ values: NSSet)

}

// MARK: Generated accessors for custommealentry
extension Food {

    @objc(addCustommealentryObject:)
    @NSManaged public func addToCustommealentry(_ value: CustomMealEntry)

    @objc(removeCustommealentryObject:)
    @NSManaged public func removeFromCustommealentry(_ value: CustomMealEntry)

    @objc(addCustommealentry:)
    @NSManaged public func addToCustommealentry(_ values: NSSet)

    @objc(removeCustommealentry:)
    @NSManaged public func removeFromCustommealentry(_ values: NSSet)

}

extension Food : Identifiable {

}
