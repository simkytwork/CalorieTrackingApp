//
//  CustomMealDetailViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 14/03/2024.
//

import UIKit
import CoreData

class CustomMealDetailViewController: UIViewController, UITextFieldDelegate {
    private var contentView = CustomMealDetailView()
    private var customMeal: CustomMeal
    private var existingFoodEntry: FoodEntry?
    private var meal: Meal
    private var kcal: Double
    private var carbs: Double
    private var protein: Double
    private var fat: Double
    private var servingSize: Double
    
    init(meal: Meal, customMeal: CustomMeal, foodEntry: FoodEntry? = nil) {
        self.meal = meal
        self.customMeal = customMeal
        self.existingFoodEntry = foodEntry
        self.kcal = existingFoodEntry?.kcal ?? customMeal.kcal
        self.carbs = existingFoodEntry?.carbs ?? customMeal.carbs
        self.protein = existingFoodEntry?.protein ?? customMeal.protein
        self.fat = existingFoodEntry?.fat ?? customMeal.fat
        self.servingSize = existingFoodEntry?.servingsize ?? customMeal.size
        
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
        
        self.title = customMeal.wrappedName
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
        
        contentView.onAddMealFoodTapped = { [weak self] in
            self?.addMealFoodTapped()
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
        foodEntry.custommeal = customMeal
        foodEntry.meal = meal
        foodEntry.servingsize = localeDouble(from: contentView.getAmountTextFieldText()) ?? 0.0
        foodEntry.servingunit = "Serving"
        
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
            customMeal.addToFoodentry(foodEntry)
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
    
    private func recalculateAndRefreshUI(){
        guard let text = contentView.getAmountTextFieldText(), !text.isEmpty else {
            return
        }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        
        if let number = formatter.number(from: text) {
            let multiplier = number.doubleValue
            self.kcal = customMeal.kcal * multiplier
            self.carbs = customMeal.carbs * multiplier
            self.protein = customMeal.protein * multiplier
            self.fat = customMeal.fat * multiplier
            self.servingSize = customMeal.size * multiplier
            updateNutritionSummaryInfo()
            
            let prettyFormatter = NumberFormatter()
            prettyFormatter.minimumFractionDigits = 0
            prettyFormatter.maximumFractionDigits = 2
            prettyFormatter.numberStyle = .decimal
            let amountText = prettyFormatter.string(from: NSNumber(value: multiplier)) ?? "1"
            contentView.updateNutritionLabel(with: "\(amountText) x Servings")
        } else {
            self.kcal = customMeal.kcal
            self.carbs = customMeal.carbs
            self.protein = customMeal.protein
            self.fat = customMeal.fat
            self.servingSize = customMeal.size
            updateNutritionSummaryInfo()
            contentView.updateNutritionLabel(with: "1 Serving")
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
