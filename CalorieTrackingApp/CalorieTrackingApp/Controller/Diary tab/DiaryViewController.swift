//
//  ViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 13/02/2024.
//

import UIKit
import CoreData

class DiaryViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    let contentView = DiaryView()
    let datePickerVC = DatePickerViewController()
    private var selectedDate = Date() {
        didSet {
            fetchAllMealsInfo()
        }
    }
    
    private var kcal = 0.0
    private var protein = 0.0
    private var carbs = 0.0
    private var fat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1)
        self.title = "Diary"
        
        let accountImage = AuthManager.shared.isLoggedIn() ? UIImage(systemName: "person.crop.circle.badge.checkmark") : UIImage(systemName: "person.crop.circle")
        let rightBarButtonItem = UIBarButtonItem(image: accountImage, style: .plain, target: self, action: #selector(accountButtonTapped))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationController?.navigationBar.tintColor = .systemOrange
        
        setupContentView()
        fetchAllMealsInfo()
        configureViewActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let accountImage = AuthManager.shared.isLoggedIn() ? UIImage(systemName: "person.crop.circle.badge.checkmark") : UIImage(systemName: "person.crop.circle")
        self.navigationItem.rightBarButtonItem?.image = accountImage
        
        if let tabBar = self.tabBarController as? MainTabBarController {
            tabBar.trackButtonView.isHidden = false
        }
        fetchAllMealsInfo()
    }
    
    private func setupContentView() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureViewActions() {
        contentView.onDateLabelTapped = { [weak self] in
            self?.presentDatePicker()
        }
        
        contentView.onIncrementDateTapped = { [weak self] in
            self?.incrementDate()
        }
        
        contentView.onDecrementDateTapped = { [weak self] in
            self?.decrementDate()
        }
        
        contentView.mealBarTapped = { [weak self] mealName in
            guard let self = self, let meal = self.fetchOrCreateMeal(name: mealName, date: self.selectedDate) else { return }
            let mealViewController = MealViewController(meal: meal)
            self.navigationController?.pushViewController(mealViewController, animated: true)
        }
    }
    
    @objc func accountButtonTapped() {
        let signinVC = SigninViewController()
        signinVC.hidesBottomBarWhenPushed = true
        if let tabBar = self.tabBarController as? MainTabBarController {
            tabBar.trackButtonView.isHidden = true
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(signinVC, animated: true)
    }
    
    private func fetchOrCreateMeal(name mealName: String, date: Date) -> Meal? {
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
    
    private func fetchAllMealsInfo() {
        let mealTypes = Constants.mealNames
        
        kcal = 0.0
        protein = 0.0
        carbs = 0.0
        fat = 0.0
        
        mealTypes.forEach { mealType in
            if let meal = fetchOrCreateMeal(name: mealType, date: selectedDate) {
                kcal += meal.kcal
                protein += meal.protein
                carbs += meal.carbs
                fat += meal.fat
                
                self.contentView.updateKcalValue(forMealName: mealType, withKcal: Int(meal.kcal))
            }
        }
        
        self.updateNutritionSummaryInfo()
    }
    
    func updateNutritionSummaryInfo() {
        let totalWeight = protein + carbs + fat
        let proteinPercentage = totalWeight > 0 ? (protein / totalWeight) * 100 : 0
        let carbsPercentage = totalWeight > 0 ? (carbs / totalWeight) * 100 : 0
        let fatPercentage = totalWeight > 0 ? (fat / totalWeight) * 100 : 0
        
        let proteinValue = "(\(String(format: "%.1f", proteinPercentage))%) - \(String(format: "%.1f", protein))g"
        let carbsValue = "(\(String(format: "%.1f", carbsPercentage))%) - \(String(format: "%.1f", carbs))g"
        let fatValue = "(\(String(format: "%.1f", fatPercentage))%) - \(String(format: "%.1f", fat))g"
        
        contentView.updateNutritionSummaryInfo(
            kcal: String(format: "%.0f", kcal),
            protein: proteinValue,
            carbs: carbsValue,
            fat: fatValue
        )
    }
    
    @objc func presentDatePicker() {
        datePickerVC.modalPresentationStyle = .popover
        datePickerVC.preferredContentSize = CGSize(width: 320, height: 400)
        datePickerVC.popoverPresentationController?.sourceView = contentView.popoverSourceView()
        datePickerVC.popoverPresentationController?.sourceRect = contentView.popoverSourceRect()
        datePickerVC.popoverPresentationController?.permittedArrowDirections = .any
        datePickerVC.popoverPresentationController?.delegate = self
        
        datePickerVC.dateSelected = { [weak self] selectedDate in
            self?.contentView.updateDateLabel(with: selectedDate)
            self?.contentView.updateDayNameLabel(with: selectedDate)
            self?.selectedDate = selectedDate
            self?.dismiss(animated: true, completion: nil)
        }
        
        // without checking if it's already being presented, sometimes the app crashes because it tries to present it modally as well
        if self.presentedViewController == nil {
            datePickerVC.updateDatePickerDate(with: selectedDate)
            present(datePickerVC, animated: true, completion: nil)
        }
    }
    
    @objc private func decrementDate() {
        let currentDate = selectedDate
        let newDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        contentView.updateDateLabel(with: newDate)
        contentView.updateDayNameLabel(with: newDate)
        selectedDate = newDate
    }

    @objc private func incrementDate() {
        let currentDate = selectedDate
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        contentView.updateDateLabel(with: newDate)
        contentView.updateDayNameLabel(with: newDate)
        selectedDate = newDate
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

