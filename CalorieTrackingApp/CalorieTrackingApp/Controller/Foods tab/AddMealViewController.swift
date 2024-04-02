//
//  AddMealViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 12/03/2024.
//

import UIKit
import CoreData

class AddMealViewController: UIViewController {

    private var contentView = AddMealView()
    private var meal: CustomMeal
    private var childContext: NSManagedObjectContext
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let meal = CustomMeal(context: managedContext)
        meal.id = UUID()
        meal.name = ""
        meal.wasDeleted = false
        self.meal = meal
        self.childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.childContext.parent = appDelegate.persistentContainer.viewContext
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let meal = CustomMeal(context: managedContext)
        meal.id = UUID()
        self.meal = meal
        self.childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.childContext.parent = appDelegate.persistentContainer.viewContext
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Meal"
        self.navigationController?.navigationBar.tintColor = .systemOrange
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        // for keyboard dismissal
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        contentView.setTableViewDelegate(self)
        contentView.setTableViewDataSource(self)
        contentView.registerTableViewCell(cellClass: MealEntryTableViewCell.self, forCellReuseIdentifier: "MealEntryCell")
        
        contentView.onAddMealFoodTapped = { [weak self] in
            self?.addMealFoodTapped()
        }
    
        contentView.onCreateMealTapped = { [weak self] in
            self?.createMealTapped()
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "X", style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentView.reloadTableViewData()
        self.updateNutritionSummaryInfo()
    }
    
    private func deleteCustomMealEntry(at indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext

        let entryToDelete = meal.customMealEntryArray[indexPath.row]
        
        managedContext.delete(entryToDelete)
        meal.removeFromCustommealentry(entryToDelete)
        
        updateNutritionSummaryInfo()
    }
    
    @objc private func addMealFoodTapped() {
        if let tabBarVC = self.tabBarController as? MainTabBarController {
            UIView.animate(withDuration: 0.03, delay: 0.01, animations: {
                tabBarVC.trackButtonView.alpha = 0.0
            }) { _ in
                tabBarVC.trackButtonView.isHidden = true
            }
        }
        
        let mealID = self.meal.objectID
        let childMeal = childContext.object(with: mealID) as? CustomMeal
        let customMealEntry = CustomMealEntry(context: childContext)
        customMealEntry.id = UUID()
        customMealEntry.custommeal = childMeal
        
        childMeal!.addToCustommealentry(customMealEntry)
        
        let mealFoodSelectionVC = MealFoodSelectionViewController(customMealEntry: customMealEntry, context: childContext)
        mealFoodSelectionVC.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(mealFoodSelectionVC, animated: true)
    }
    
    @objc private func createMealTapped() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let name = contentView.getNameFieldText(), isNotEmpty(name), meal.customMealEntryArray.count != 0 else {
            showAlertWith(message: "Please enter a meal name and at least one meal food!")
            return
        }
        
        for entry in meal.customMealEntryArray {
            meal.kcal += entry.kcal
            meal.protein += entry.protein
            meal.carbs += entry.carbs
            meal.fat += entry.fat
        }
        
        meal.name = contentView.getNameFieldText()
        meal.size = 1.0
        
        do {
            try managedContext.save()
        } catch {
            print("Failed to save food: \(error)")
        }
        
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count >= 2 else {
                return
            }
            
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
        }
    }
    
    @objc func backButtonTapped() {
        if let nameText = contentView.getNameFieldText(), !isNotEmpty(nameText), meal.customMealEntryArray.isEmpty {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            childContext.rollback()
            managedContext.rollback()
            
            self.navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "Create meal", message: "Would you like to create this meal?", preferredStyle: .alert)
            
            let discardAction = UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
                guard let self = self, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                managedContext.rollback()
                
                self.navigationController?.popViewController(animated: true)
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                self?.createMealTapped()
            }
            
            alertController.addAction(discardAction)
            alertController.addAction(saveAction)
            
            present(alertController, animated: true)
        }
    }
    
    private func isNotEmpty(_ input: String) -> Bool {
        return !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func updateNutritionSummaryInfo() {
        var totalKcal = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0
        var totalFat = 0.0
        
        for entry in meal.customMealEntryArray {
            totalKcal += entry.kcal
            totalProtein += entry.protein
            totalCarbs += entry.carbs
            totalFat += entry.fat
        }
        
        contentView.updateNutritionSummaryInfo(
            kcal: totalKcal,
            protein: totalProtein,
            carbs: totalCarbs,
            fat: totalFat
        )
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlertWith(message: String) {
        let alert = UIAlertController(title: "Enter required details", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

extension AddMealViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meal.customMealEntryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealEntryCell", for: indexPath) as? MealEntryTableViewCell else {
            return UITableViewCell()
        }
        let mealEntry = meal.customMealEntryArray[indexPath.row]
        cell.setupMealEntryCell(with: mealEntry)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCustomMealEntry(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // for later tap implementation
    }
}

class MealEntryTableViewCell: UITableViewCell {
    let stackView = UIView()
    let nameLabel = UILabel()
    let kcalLabel = UILabel()
    let servingDetailsLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 6
        stackView.layer.borderColor = UIColor.systemGray6.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.backgroundColor = .white
        stackView.layer.masksToBounds = false
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.05
        stackView.layer.shadowOffset = CGSize(width: 0, height: 1)
        stackView.layer.shadowRadius = 1
        
        contentView.addSubview(stackView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        kcalLabel.translatesAutoresizingMaskIntoConstraints = false
        servingDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addSubview(nameLabel)
        stackView.addSubview(kcalLabel)
        stackView.addSubview(servingDetailsLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            nameLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -56),
            
            kcalLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            kcalLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            kcalLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10),
            
            servingDetailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            servingDetailsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            servingDetailsLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            servingDetailsLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10),
        ])
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        stackView.backgroundColor = highlighted ? UIColor.systemOrange : .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupMealEntryCell(with customMealEntry: CustomMealEntry) {
        nameLabel.text = customMealEntry.food?.name
        nameLabel.font = .boldSystemFont(ofSize: 15)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        kcalLabel.text = String(format: "%.0f", customMealEntry.kcal) + " kcal"
        kcalLabel.font = .systemFont(ofSize: 13)
        
//        let servingText = customMealEntry.food?.wrappedServing
        let perservingText = customMealEntry.food?.wrappedPerServing

        let sizeText = String(format: "%.0f", customMealEntry.servingsize)

        servingDetailsLabel.text = "\(sizeText)\(perservingText ?? "")"
        servingDetailsLabel.font = .systemFont(ofSize: 13)
        
        contentView.layoutIfNeeded()
    }
}
