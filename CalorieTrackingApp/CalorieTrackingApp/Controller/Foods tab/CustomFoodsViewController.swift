//
//  CustomFoodsViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 14/02/2024.
//

import UIKit
import CoreData

class CustomFoodsViewController: UIViewController {

    private var contentView = CustomFoodsView()
    private var foods: [Food] = []
    private var filteredFoods: [Food] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Custom Foods"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
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
        
        fetchFoods()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFoods()
    }
    
    private func isSearching() -> Bool {
        return searchController.isActive || !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    private func fetchFoods() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "wasDeleted == FALSE AND isFromDatabase == FALSE")
        
        do {
            foods = try managedContext.fetch(fetchRequest)
            self.contentView.updatePlaceholderVisibility(show: !self.hasFood)
            self.contentView.reloadTableViewData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func deleteFood(at indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext

        let foodToDelete = foods[indexPath.row]

        foodToDelete.wasDeleted = true

        foods.remove(at: indexPath.row)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error saving after soft deletion: \(error), \(error.userInfo)")
        }
    }
    
    @objc private func addButtonTapped() {
        let addFoodVC = AddFoodViewController()
        let navController = UINavigationController(rootViewController: addFoodVC)
        navController.modalPresentationStyle = .fullScreen
        
        self.present(navController, animated: true, completion: nil)
    }
    
    private var hasFood: Bool {
        return !foods.isEmpty || !filteredFoods.isEmpty
    }
}






extension CustomFoodsViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFood(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // for later tap implementation
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
    
    func willPresentSearchController(_ searchController: UISearchController) {
        contentView.updatePlaceholderVisibility(show: false)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        if hasFood {
            contentView.updatePlaceholderVisibility(show: false)
        } else {
            contentView.updatePlaceholderVisibility(show: true)
        }
    }
}
