//
//  CustomMealEntry+CoreDataProperties.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 12/03/2024.
//
//

import Foundation
import CoreData


extension CustomMealEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomMealEntry> {
        return NSFetchRequest<CustomMealEntry>(entityName: "CustomMealEntry")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var kcal: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
    @NSManaged public var protein: Double
    @NSManaged public var servingsize: Double
    @NSManaged public var servingunit: String?
    public var wrappedServingUnit: String {
        servingunit ?? "Unknown serving unit"
    }
    @NSManaged public var food: Food?
    @NSManaged public var custommeal: CustomMeal?
}

extension CustomMealEntry : Identifiable {

}
