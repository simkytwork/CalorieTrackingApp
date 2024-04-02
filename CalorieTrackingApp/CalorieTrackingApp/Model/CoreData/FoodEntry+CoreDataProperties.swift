//
//  FoodEntry+CoreDataProperties.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 16/02/2024.
//
//

import Foundation
import CoreData


extension FoodEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntry> {
        return NSFetchRequest<FoodEntry>(entityName: "FoodEntry")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var servingunit: String?
    public var wrappedServingUnit: String {
        servingunit ?? "Unknown serving unit"
    }
    @NSManaged public var servingsize: Double
    @NSManaged public var kcal: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
    @NSManaged public var protein: Double
    @NSManaged public var food: Food?
    @NSManaged public var meal: Meal?
    @NSManaged public var custommeal: CustomMeal?

}

extension FoodEntry : Identifiable {

}
