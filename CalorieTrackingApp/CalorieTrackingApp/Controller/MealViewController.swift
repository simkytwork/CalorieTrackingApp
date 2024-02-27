//
//  MealViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 26/02/2024.
//

import UIKit
import CoreData

class MealViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {

    private var contentView = MealView()
    private var meal: Meal
    private var filteredFoods: [Food] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchDebounceTimer: Timer?
    
    init(meal: Meal) {
        self.meal = meal
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.register(FoodTableViewCell.self, forCellReuseIdentifier: "FoodCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if hasFoodEntries {
            contentView.updatePlaceholderVisibility(show: false)
            contentView.updateTableViewTopConstraint(isSearching: false)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchDebounceTimer?.invalidate()
        
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { [weak self] (_) in
            if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                self?.filterContentForSearchText(searchText)
            } else {
                self?.filteredFoods = []
                DispatchQueue.main.async {
                    self?.contentView.tableView.reloadData()
                }
            }
        })
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
        
        do {
            filteredFoods = try managedContext.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.contentView.tableView.reloadData()
            }
        } catch let error as NSError {
            print("Could not fetch. Error: \(error), \(error.userInfo)")
        }
    }
    
    var isSearching: Bool {
        return searchController.isActive || !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
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
            let food = filteredFoods[indexPath.row]
            cell.setupCell(with: food, showActionButton: true)
            cell.onActionButtonPressed = { [weak self] in
                guard let self = self else { return }
                self.trackFood(food)
                self.searchController.isActive = false
                DispatchQueue.main.async {
                    self.contentView.tableView.reloadData()
                }
            }
        } else if hasFoodEntries {
            let foodEntry = meal.foodEntryArray[indexPath.row]
            cell.setupCell(with: foodEntry.food!, showActionButton: false)
        }
        return cell
    }
    
    private func trackFood(_ food: Food) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
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
    
    private var hasFoodEntries: Bool {
        return !meal.foodEntryArray.isEmpty
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // for later tap implementation
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        contentView.updateTableViewTopConstraint(isSearching: true)
        contentView.updatePlaceholderVisibility(show: false)
        contentView.updateNutritionalInfoVisibility(show: false)
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        if !hasFoodEntries {
            contentView.updatePlaceholderVisibility(show: true)
        } else {
            contentView.updateTableViewTopConstraint(isSearching: false)
            contentView.updatePlaceholderVisibility(show: false)
        }
        contentView.updateNutritionalInfoVisibility(show: true)
    }
}
