//
//  SelectionDetailedViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 12/03/2024.
//

import UIKit
import CoreData

class SelectionDetailedViewController: UIViewController, UITextFieldDelegate {
    private var contentView = SelectionDetailedView()
    private var food: Food
    private var customMealEntry: CustomMealEntry
    private var context: NSManagedObjectContext
    private var servingType: String
    private let servingTypeOptions: [String]
    
    init(customMealEntry: CustomMealEntry, food: Food, context: NSManagedObjectContext) {
        self.food = food
        self.customMealEntry = customMealEntry
        self.customMealEntry.kcal = food.kcal
        self.customMealEntry.carbs = food.carbs
        self.customMealEntry.protein = food.protein
        self.customMealEntry.fat = food.fat
        self.customMealEntry.servingunit = food.perserving
        self.customMealEntry.servingsize = food.size
        self.context = context
        self.servingTypeOptions = [food.wrappedServing, food.wrappedPerServing]
        self.servingType = food.wrappedServing
        
        contentView.setServingType(to: servingType)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = food.wrappedName
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        recalculateAndRefreshUI()
        
        // for keyboard dismissal
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        contentView.configureTextFieldChangeHandler(target: self, action: #selector(textFieldDidChange(_:)))
        contentView.setAmountTextFieldDelegate(self)
        
        contentView.onAddMealFoodTapped = { [weak self] in
            self?.addMealFoodTapped()
        }
        
        contentView.configureServingTypeMenu(withOptions: servingTypeOptions)
        contentView.onServingTypeSelected = { [weak self] selectedContent in
            self?.servingType = selectedContent
            self?.recalculateAndRefreshUI()
        }
    }

    private func updateNutritionSummaryInfo() {
        contentView.updateNutritionSummaryInfo(
            kcal: customMealEntry.kcal,
            protein: customMealEntry.protein,
            carbs: customMealEntry.carbs,
            fat: customMealEntry.fat
        )
    }
    
    @objc private func addMealFoodTapped() {
        guard let text = contentView.getAmountTextFieldText(),
              let _ = NumberFormatter().number(from: text) else {
            showAlertWith(message: "Please enter a valid serving amount!")
            return
        }
        
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count >= 3 else {
                return
            }
            
            customMealEntry.food = food
            food.addToCustommealentry(customMealEntry)
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Failed to save child context: \(error), \(error.userInfo)")
            }
            
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        recalculateAndRefreshUI()
    }
    
    private func recalculateAndRefreshUI() {
        guard let text = contentView.getAmountTextFieldText(), !text.isEmpty else {
            return
        }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        
        let prettyFormatter = NumberFormatter()
        prettyFormatter.minimumFractionDigits = 0
        prettyFormatter.maximumFractionDigits = 2
        prettyFormatter.numberStyle = .decimal
        
        if let number = formatter.number(from: text) {
            let amountEntered = number.doubleValue
            let multiplier: Double
            
            switch servingType {
            case "g", "mL":
                multiplier = amountEntered / food.size
            case "Standard serving", "Large serving", "Small serving":
                multiplier = amountEntered
            default:
                multiplier = 1.0
            }
            
            self.customMealEntry.kcal = food.kcal * multiplier
            self.customMealEntry.carbs = food.carbs * multiplier
            self.customMealEntry.protein = food.protein * multiplier
            self.customMealEntry.fat = food.fat * multiplier
            self.customMealEntry.servingsize = food.size * multiplier
        
            let amountText = formatter.string(from: NSNumber(value: amountEntered)) ?? "1"
            
            if servingType == "Small serving" || servingType == "Standard serving" || servingType == "Large serving" {
                contentView.updateNutritionLabel(with: "\(amountText) x \(servingType)")
            } else {
                contentView.updateNutritionLabel(with: "\(amountText) \(servingType)")
            }
            
            updateNutritionSummaryInfo()
        } else {
            self.customMealEntry.kcal = food.kcal
            self.customMealEntry.carbs = food.carbs
            self.customMealEntry.protein = food.protein
            self.customMealEntry.fat = food.fat
            self.customMealEntry.servingsize = 1.0
            contentView.updateNutritionLabel(with: "\(customMealEntry.servingsize) \(servingType)")
            updateNutritionSummaryInfo()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            let newPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlertWith(message: String) {
        let alert = UIAlertController(title: "Invalid serving amount", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
