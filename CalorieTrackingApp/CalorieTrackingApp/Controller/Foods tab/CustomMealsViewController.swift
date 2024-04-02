//
//  CustomMealsViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 12/03/2024.
//

import UIKit
import CoreData

class CustomMealsViewController: UIViewController {

    private var contentView = CustomMealsView()
    private var customMeals: [CustomMeal] = []
    private var filteredCustomMeals: [CustomMeal] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Custom Meals"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .systemOrange
        self.navigationController?.navigationBar.tintColor = .systemOrange
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Meal name"
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
        contentView.registerTableViewCell(cellClass: CustomMealTableViewCell.self, forCellReuseIdentifier: "CustomMealCell")
        
        fetchCustomMeals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCustomMeals()
    }
    
    private func isSearching() -> Bool {
        return searchController.isActive || !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    private func fetchCustomMeals() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CustomMeal> = CustomMeal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "wasDeleted == FALSE")
        
        do {
            customMeals = try managedContext.fetch(fetchRequest)
            self.contentView.updatePlaceholderVisibility(show: !self.hasCustomMeals)
            self.contentView.reloadTableViewData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func deleteCustomMeal(at indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext

        let customMealToDelete = customMeals[indexPath.row]

        customMealToDelete.wasDeleted = true

        customMeals.remove(at: indexPath.row)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error saving after soft deletion: \(error), \(error.userInfo)")
        }
    }
    
    @objc private func addButtonTapped() {
        if let tabBarVC = self.tabBarController as? MainTabBarController {
            UIView.animate(withDuration: 0.03, delay: 0.01, animations: {
                tabBarVC.trackButtonView.alpha = 0.0
            }) { _ in
                tabBarVC.trackButtonView.isHidden = true
            }
        }
        
        let addMealVC = AddMealViewController()
        addMealVC.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(addMealVC, animated: true)
    }
    
    private var hasCustomMeals: Bool {
        return !customMeals.isEmpty || !filteredCustomMeals.isEmpty
    }
}

extension CustomMealsViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching() {
            return filteredCustomMeals.count
        }
        return customMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMealCell", for: indexPath) as? CustomMealTableViewCell else {
            return UITableViewCell()
        }
        let customMeal = isSearching() ? filteredCustomMeals[indexPath.row] : customMeals[indexPath.row]
        cell.setupCustomMealCell(with: customMeal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCustomMeal(at: indexPath)
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
        filteredCustomMeals = customMeals.filter { (customMeal: CustomMeal) -> Bool in
            return customMeal.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
        
        self.contentView.reloadTableViewData()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        contentView.updatePlaceholderVisibility(show: false)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        if hasCustomMeals {
            contentView.updatePlaceholderVisibility(show: false)
        } else {
            contentView.updatePlaceholderVisibility(show: true)
        }
    }
}
