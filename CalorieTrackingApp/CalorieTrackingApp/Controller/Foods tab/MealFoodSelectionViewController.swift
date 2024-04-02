//
//  MealFoodSelectionViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 12/03/2024.
//

import UIKit
import CoreData

class MealFoodSelectionViewController: UIViewController {

    private var contentView = MealFoodSelectionView()
    private var customMealEntry: CustomMealEntry
    private var context: NSManagedObjectContext
    
    private var foods: [Food] = []
    private var filteredFoods: [Food] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    init(customMealEntry: CustomMealEntry, context: NSManagedObjectContext) {
        self.customMealEntry = customMealEntry
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Food selection"
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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "X", style: .plain, target: self, action: #selector(backButtonTapped))
        
        fetchFoods()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFoods()
        if !hasFood {
            searchController.searchBar.isUserInteractionEnabled = false
        }
    }
    
    private func isSearching() -> Bool {
        return searchController.isActive || !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    private func fetchFoods() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "wasDeleted == FALSE AND isFromDatabase == FALSE")
        
        do {
            foods = try context.fetch(fetchRequest)
            self.contentView.updatePlaceholderVisibility(show: !self.hasFood)
            self.contentView.reloadTableViewData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @objc func backButtonTapped() {
        context.rollback()
        self.navigationController?.popViewController(animated: true)
    }
    
    private var hasFood: Bool {
        return !foods.isEmpty || !filteredFoods.isEmpty
    }
}

extension MealFoodSelectionViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching() {
            return filteredFoods.count
        }
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as? FoodTableViewCell else {
            return UITableViewCell()
        }
        let food = isSearching() ? filteredFoods[indexPath.row] : foods[indexPath.row]
        cell.setupLocalFoodCell(with: food, showActionButton: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = isSearching() ? filteredFoods[indexPath.row] : foods[indexPath.row]
        
        let selectionDetailedViewController = SelectionDetailedViewController(customMealEntry: customMealEntry, food: food, context: context)
        selectionDetailedViewController.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(selectionDetailedViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredFoods = foods.filter { (food: Food) -> Bool in
            return food.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
        
        self.contentView.reloadTableViewData()
    }
}
