//
//  MealViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 26/02/2024.
//

import UIKit
import CoreData

class MealViewController: UIViewController {

    private var contentView = MealView()
    private var meal: Meal
    
    private var filteredFoods: [FoodItem] = []
    private enum FoodItem {
        case local(Food) // local (Core Data) food
        case remote(EdamamItem) // remote (Edamam API) food
        case customMeal(CustomMeal) // remote (Edamam API) food
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchDebounceTimer: Timer?
    
    init(meal: Meal) {
        self.meal = meal
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getMeal() -> Meal {
        return self.meal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = meal.type
        navigationItem.rightBarButtonItem?.tintColor = .systemOrange
        self.navigationController?.navigationBar.tintColor = .systemOrange
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Food name"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        contentView.setTableViewDelegate(self)
        contentView.setTableViewDataSource(self)
        contentView.registerTableViewCell(cellClass: FoodTableViewCell.self, forCellReuseIdentifier: "FoodCell")
        NotificationCenter.default.addObserver(self, selector: #selector(deactivateSearch), name: .deactivateSearchController, object: nil)
        updateNutritionSummaryInfo()
        
        if hasFoodEntries {
            contentView.updatePlaceholderVisibility(show: false)
            contentView.updateTableViewTopConstraint(isSearching: false)
            contentView.updateTableLabelVsibility(show: true)
        } else {
            contentView.updateTableLabelVsibility(show: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isSearching {
            contentView.updateTableViewTopConstraint(isSearching: true)
        } else {
            if let tabBarVC = self.tabBarController as? MainTabBarController {
                UIView.animate(withDuration: 0.03, delay: 0.01, animations: {
                    tabBarVC.trackButtonView.alpha = 1.0
                }) { _ in
                    tabBarVC.trackButtonView.isHidden = false
                    tabBarVC.trackButtonView.setButtonEnabled(true)
                    tabBarVC.trackButtonView.shouldAcceptTouches = true
                }
            }
            contentView.reloadTableViewData()
        }

    }
    
    func activateSearch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.searchController.isActive = true
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    private var isSearching: Bool {
        return searchController.isActive || !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    private func trackLocalFood(_ food: Food) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let newFoodEntry = FoodEntry(context: managedContext)
        newFoodEntry.id = UUID()
        newFoodEntry.food = food
        newFoodEntry.meal = meal
        newFoodEntry.servingsize = 1
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        let sizeText = formatter.string(from: NSNumber(value: food.size)) ?? "1"
        newFoodEntry.servingunit = "\(food.wrappedServing)"
        
        newFoodEntry.kcal = food.kcal
        newFoodEntry.carbs = food.carbs
        newFoodEntry.protein = food.protein
        newFoodEntry.fat = food.fat
        
        food.addToFoodentry(newFoodEntry)
        
        meal.kcal += food.kcal
        meal.carbs += food.carbs
        meal.fat += food.fat
        meal.protein += food.protein
        meal.addToFoodentry(newFoodEntry)
        
        do {
            try managedContext.save()
        } catch {
            print("Error saving food: \(error)")
        }
    }
    
    private func trackRemoteFood(_ remoteFood: EdamamItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let food = Food(context: managedContext)
        food.id = UUID()
        food.name = remoteFood.label
        food.category = "Imported from Edamam"
        food.kcal = remoteFood.nutrients.ENERC_KCAL
        food.carbs = remoteFood.nutrients.CHOCDF
        food.protein = remoteFood.nutrients.PROCNT
        food.fat = remoteFood.nutrients.FAT
        food.size = 100.0
        food.serving = "Standard serving"
        food.perserving = "g"
        food.wasDeleted = false
        food.isFromDatabase = true
        
        let newFoodEntry = FoodEntry(context: managedContext)
        newFoodEntry.id = UUID()
        newFoodEntry.food = food
        newFoodEntry.meal = meal
        newFoodEntry.servingsize = 1
        newFoodEntry.servingunit = "\(food.wrappedServing) (\(food.size) \(food.wrappedPerServing))"
        newFoodEntry.kcal = food.kcal
        newFoodEntry.carbs = food.carbs
        newFoodEntry.protein = food.protein
        newFoodEntry.fat = food.fat
        
        food.addToFoodentry(newFoodEntry)
        
        meal.kcal += food.kcal
        meal.carbs += food.carbs
        meal.fat += food.fat
        meal.protein += food.protein
        meal.addToFoodentry(newFoodEntry)
        
        do {
            try managedContext.save()
        } catch {
            print("Error saving food: \(error)")
        }
    }
    
    private func trackCustomMeal(_ customMeal: CustomMeal) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let newFoodEntry = FoodEntry(context: managedContext)
        newFoodEntry.id = UUID()
        newFoodEntry.custommeal = customMeal
        newFoodEntry.meal = meal
        newFoodEntry.servingsize = customMeal.size
        newFoodEntry.servingunit = "Serving"
        newFoodEntry.kcal = customMeal.kcal
        newFoodEntry.carbs = customMeal.carbs
        newFoodEntry.protein = customMeal.protein
        newFoodEntry.fat = customMeal.fat
        
        customMeal.addToFoodentry(newFoodEntry)
        
        meal.kcal += customMeal.kcal
        meal.carbs += customMeal.carbs
        meal.fat += customMeal.fat
        meal.protein += customMeal.protein
        meal.addToFoodentry(newFoodEntry)
        
        do {
            try managedContext.save()
        } catch {
            print("Error saving food: \(error)")
        }
    }
    
    private func deleteFood(at indexPath: IndexPath) {
        
        guard let id = meal.foodEntryArray[indexPath.row].id else {
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext

        if let indexToDelete = meal.foodEntryArray.firstIndex(where: { $0.id == id }) {
            let foodEntryToDelete = meal.foodEntryArray[indexToDelete]
            
            meal.kcal -= foodEntryToDelete.kcal
            meal.carbs -= foodEntryToDelete.carbs
            meal.fat -= foodEntryToDelete.fat
            meal.protein -= foodEntryToDelete.protein
            
            // to ensure values are not very small because of Double precision issues (values can become as small as -2.842170943040401e-14 and so on)
            let tolerance: Double = 1e-10
            meal.kcal = abs(meal.kcal) < tolerance ? 0 : meal.kcal
            meal.carbs = abs(meal.carbs) < tolerance ? 0 : meal.carbs
            meal.protein = abs(meal.protein) < tolerance ? 0 : meal.protein
            meal.fat = abs(meal.fat) < tolerance ? 0 : meal.fat
            
            foodEntryToDelete.food?.removeFromFoodentry(foodEntryToDelete)
            foodEntryToDelete.custommeal?.removeFromFoodentry(foodEntryToDelete)
            managedContext.delete(foodEntryToDelete)
            
            meal.removeFromFoodentry(foodEntryToDelete)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error saving after deleting food: \(error), \(error.userInfo)")
            }
        }
    }
    
    private func updateNutritionSummaryInfo() {
        contentView.updateNutritionSummaryInfo(
            kcal: meal.kcal,
            protein: meal.protein,
            carbs: meal.carbs,
            fat: meal.fat
        )
    }
    
    private var hasFoodEntries: Bool {
        return !meal.foodEntryArray.isEmpty
    }
    
    private func openLocalFoodDetailView(with food: Food) {
        let detailVC = FoodDetailViewController(meal: meal, food: food)
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    private func openRemoteFoodDetailView(with food: EdamamItem) {
//        let detailVC = LocalFoodDetailViewController()
//        detailVC.food = food
//        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func openCustomMealDetailView(with customMeal: CustomMeal) {
        let detailVC = CustomMealDetailViewController(meal: meal, customMeal: customMeal)
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc private func deactivateSearch() {
        self.searchController.isActive = false
        self.updateNutritionSummaryInfo()
    }
}

extension MealViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredFoods.count
        } else if hasFoodEntries {
            return meal.foodEntryArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as? FoodTableViewCell else {
            return UITableViewCell()
        }
        
        if isSearching {
            switch filteredFoods[indexPath.row] {
            case .local(let food):
                cell.setupLocalFoodCell(with: food, showActionButton: true)
                cell.onActionButtonPressed = { [weak self] in
                    guard let self = self else { return }
                    self.trackLocalFood(food)
                    self.updateNutritionSummaryInfo()
                    self.searchController.isActive = false
                    self.contentView.reloadTableViewData()
                }
            case .remote(let edamamItem):
                cell.setupEdamamFoodCell(with: edamamItem, showActionButton: true)
                cell.onActionButtonPressed = { [weak self] in
                    guard let self = self else { return }
                    self.trackRemoteFood(edamamItem)
                    self.updateNutritionSummaryInfo()
                    self.searchController.isActive = false
                    self.contentView.reloadTableViewData()
                }
            case .customMeal(let customMealItem):
                cell.setupCustomMealCell(with: customMealItem, showActionButton: true)
                cell.onActionButtonPressed = { [weak self] in
                    guard let self = self else { return }
                    self.trackCustomMeal(customMealItem)
                    self.updateNutritionSummaryInfo()
                    self.searchController.isActive = false
                    self.contentView.reloadTableViewData()
                }
            }
        } else if hasFoodEntries {
            let foodEntry = meal.foodEntryArray[indexPath.row]
            cell.setupFoodEntryCell(with: foodEntry)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isSearching
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFood(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateNutritionSummaryInfo()
            DispatchQueue.main.async {
                if tableView.numberOfRows(inSection: indexPath.section) == 0 {
                    self.contentView.updatePlaceholderVisibility(show: true)
                    self.contentView.updateTableLabelVsibility(show: false)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            
        if isSearching {
            switch filteredFoods[indexPath.row] {
            case .local(let food):
                openLocalFoodDetailView(with: food)
            case .remote(let edamamItem):
                openRemoteFoodDetailView(with: edamamItem)
            case .customMeal(let customMealItem):
                openCustomMealDetailView(with: customMealItem)
            }
        } else {
            if let tabBarVC = self.tabBarController as? MainTabBarController {
                UIView.animate(withDuration: 0.03, delay: 0.01, animations: {
                    tabBarVC.trackButtonView.alpha = 0.0
                }) { _ in
                    tabBarVC.trackButtonView.isHidden = true
                    tabBarVC.trackButtonView.setButtonEnabled(false)
                    tabBarVC.trackButtonView.shouldAcceptTouches = false
                }
            }
            
            let selectedEntry = meal.foodEntryArray[indexPath.row]

                if let food = selectedEntry.food {
                    let detailVC = FoodDetailViewController(meal: meal, food: food, foodEntry: selectedEntry)
                    detailVC.hidesBottomBarWhenPushed = true
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                    navigationController?.pushViewController(detailVC, animated: true)
                } else if let customMeal = selectedEntry.custommeal {
                    let customMealDetailVC = CustomMealDetailViewController(meal: meal, customMeal: customMeal, foodEntry: selectedEntry)
                    customMealDetailVC.hidesBottomBarWhenPushed = true
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                    navigationController?.pushViewController(customMealDetailVC, animated: true)
                }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchDebounceTimer?.invalidate()
        
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] (_) in
            if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                self?.filterContentForSearchText(searchText)
            } else {
                self?.filteredFoods = []
                self?.contentView.reloadTableViewData()
            }
        })
    }
    
    func filterContentForSearchText(_ searchText: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@ AND wasDeleted == FALSE AND isFromDatabase == FALSE", searchText)
        do {
            let localFoods = try managedContext.fetch(fetchRequest)
            self.filteredFoods = localFoods.map { .local($0) }
        } catch let error as NSError {
            print("Could not fetch. Error: \(error), \(error.userInfo)")
        }
        
        let mealFetchRequest: NSFetchRequest<CustomMeal> = CustomMeal.fetchRequest()
        mealFetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@ AND wasDeleted == FALSE", searchText)
        do {
            let customMeals = try managedContext.fetch(mealFetchRequest)
            self.filteredFoods += customMeals.map { FoodItem.customMeal($0) }
        } catch let error as NSError {
            print("Could not fetch CustomMeal. Error: \(error), \(error.userInfo)")
        }
        
        if AuthManager.shared.isLoggedIn() {
            NetworkManager.fetchFoodFromEdamam(for: searchText) { [weak self] edamamItems in
                guard let self = self, let edamamItems = edamamItems else { return }
                
                let apiFoods = edamamItems.map { FoodItem.remote($0) }
                self.filteredFoods += apiFoods
                self.contentView.reloadTableViewData()
            }
        }
        self.contentView.reloadTableViewData()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        if let tabBar = self.tabBarController as? MainTabBarController {
            tabBar.tabBar.isHidden = true
            tabBar.trackButtonView.isHidden = true
        }
        contentView.showTableView(true)
        
        contentView.updateTableViewTopConstraint(isSearching: true)
        contentView.updatePlaceholderVisibility(show: false)
        contentView.updateNutritionalInfoVisibility(show: false)
        contentView.updateTableLabelVsibility(show: false)
    }

    func didPresentSearchController(_ searchController: UISearchController) {
        contentView.showTableView(false)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        if let tabBar = self.tabBarController as? MainTabBarController {
            tabBar.tabBar.isHidden = false
            tabBar.trackButtonView.isHidden = false
        }

        contentView.showTableView(true)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        contentView.showTableView(false)
        
        if !hasFoodEntries {
            contentView.updatePlaceholderVisibility(show: true)
            contentView.updateTableLabelVsibility(show: false)
        } else {
            contentView.updatePlaceholderVisibility(show: false)
            contentView.updateTableLabelVsibility(show: true)
        }
        
        contentView.updateTableViewTopConstraint(isSearching: false)
        contentView.updateNutritionalInfoVisibility(show: true)
    }
}

extension Notification.Name {
    static let deactivateSearchController = Notification.Name("deactivateSearchController")
}
