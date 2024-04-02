//
//  FoodDetailViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 14/03/2024.
//

import UIKit
import CoreData

class FoodDetailViewController: UIViewController, UITextFieldDelegate {
    private var contentView = FoodDetailView()
    private var food: Food
    private var existingFoodEntry: FoodEntry?
    private var meal: Meal
    private var kcal: Double
    private var carbs: Double
    private var protein: Double
    private var fat: Double
    private var servingSize: Double
    private var servingType: String
    
    private let servingTypeOptions: [String]
    
    init(meal: Meal, food: Food, foodEntry: FoodEntry? = nil) {
        self.meal = meal
        self.food = food
        self.existingFoodEntry = foodEntry
        self.kcal = existingFoodEntry?.kcal ?? food.kcal
        self.carbs = existingFoodEntry?.carbs ?? food.carbs
        self.protein = existingFoodEntry?.protein ?? food.protein
        self.fat = existingFoodEntry?.fat ?? food.fat
        self.servingSize = existingFoodEntry?.servingsize ?? 1.0
        self.servingTypeOptions = [food.wrappedServing, food.wrappedPerServing]
        self.servingType = existingFoodEntry?.servingunit ?? food.wrappedServing
        
        contentView.setServingType(to: servingType)
        if existingFoodEntry != nil {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 0
            formatter.decimalSeparator = ","
            
            let servingSizeText = formatter.string(from: NSNumber(value: servingSize)) ?? "1"
            contentView.setAmountTextFieldText(to: servingSizeText)
        }
        
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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "X", style: .plain, target: self, action: #selector(backButtonTapped))
        
        recalculateAndRefreshUI()
        
        // for keyboard dismissal
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        contentView.configureTextFieldChangeHandler(target: self, action: #selector(textFieldDidChange(_:)))
        contentView.setAmountTextFieldDelegate(self)
        
        contentView.onAddFoodTapped = { [weak self] in
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
            kcal: kcal,
            protein: protein,
            carbs: carbs,
            fat: fat
        )
    }
    
    @objc private func addMealFoodTapped() {
        guard let text = contentView.getAmountTextFieldText(),
              let _ = NumberFormatter().number(from: text) else {
            showAlert(message: "Please enter a valid serving amount!")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let foodEntry = existingFoodEntry ?? FoodEntry(context: managedContext)
        foodEntry.id = UUID()
        foodEntry.food = food
        foodEntry.meal = meal
        foodEntry.servingsize = localeDouble(from: contentView.getAmountTextFieldText()) ?? 0.0
        
        if servingType == "Small serving" || servingType == "Standard serving" || servingType == "Large serving" {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            formatter.numberStyle = .decimal
            let sizeText = formatter.string(from: NSNumber(value: food.size)) ?? "1"
            
            foodEntry.servingunit = "\(servingType)"
        } else {
            foodEntry.servingunit = "\(servingType)"
        }
        
        if existingFoodEntry != nil {
            meal.kcal -= foodEntry.kcal
            meal.carbs -= foodEntry.carbs
            meal.fat -= foodEntry.fat
            meal.protein -= foodEntry.protein
        }
        
        foodEntry.kcal = kcal
        foodEntry.carbs = carbs
        foodEntry.protein = protein
        foodEntry.fat = fat
        
        if existingFoodEntry == nil {
            food.addToFoodentry(foodEntry)
            meal.addToFoodentry(foodEntry)
        }

        meal.kcal += kcal
        meal.carbs += carbs
        meal.fat += fat
        meal.protein += protein
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Failed to track food: \(error), \(error.userInfo)")
        }
        
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .deactivateSearchController, object: nil)
    }
    
    private func localeDouble(from string: String?) -> Double? {
        guard let string = string else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue
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
            
            self.kcal = food.kcal * multiplier
            self.carbs = food.carbs * multiplier
            self.protein = food.protein * multiplier
            self.fat = food.fat * multiplier
            self.servingSize = food.size * multiplier
        
            let amountText = formatter.string(from: NSNumber(value: amountEntered)) ?? "1"
            
            if servingType == "Small serving" || servingType == "Standard serving" || servingType == "Large serving" {
                contentView.updateNutritionLabel(with: "\(amountText) x \(servingType)")
            } else {
                contentView.updateNutritionLabel(with: "\(amountText) \(servingType)")
            }
            
            updateNutritionSummaryInfo()
        } else {
            self.kcal = food.kcal
            self.carbs = food.carbs
            self.protein = food.protein
            self.fat = food.fat
            self.servingSize = 1.0
            contentView.updateNutritionLabel(with: "\(servingSize) \(servingType)")
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
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid serving amount", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
