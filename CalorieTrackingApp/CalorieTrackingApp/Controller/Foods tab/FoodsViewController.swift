//
//  FoodsViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 13/02/2024.
//

import UIKit
import CoreData

class FoodsViewController: UIViewController {

    private var contentView = FoodsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFoodsView()
      }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarVC = self.tabBarController as? MainTabBarController {
            tabBarVC.trackButtonView.isHidden = false
            tabBarVC.trackButtonView.alpha = 1.0
            tabBarVC.trackButtonView.setButtonEnabled(true)
            tabBarVC.trackButtonView.shouldAcceptTouches = true
        }
        fetchFoods()
    }
    
    private func setupFoodsView() {
        self.navigationItem.title = "Foods"
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        contentView.onCustomFoodsTapped = { [weak self] in
            self?.customFoodsTapped()
        }
        
        contentView.onCustomMealsTapped = { [weak self] in
            self?.customMealsTapped()
        }
    }
    
    private func fetchFoods() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        
        let customFoodsFetchRequest = NSFetchRequest<Food>(entityName: "Food")
        customFoodsFetchRequest.predicate = NSPredicate(format: "wasDeleted == FALSE AND isFromDatabase == FALSE")
        
        let customMealsFetchRequest = NSFetchRequest<CustomMeal>(entityName: "CustomMeal")
        customMealsFetchRequest.predicate = NSPredicate(format: "wasDeleted == FALSE")
        
        do {
            let foodsCount = try context.count(for: customFoodsFetchRequest)
            let customMealsCount = try context.count(for: customMealsFetchRequest)
            DispatchQueue.main.async {
                self.updateUI(with: foodsCount, and: customMealsCount)
            }
        } catch {
            print("Failed to fetch foods: \(error)")
        }
    }
    
    private func updateUI(with foodsCount: Int, and customMealsCount: Int) {
        contentView.updateCountLabel(with: foodsCount)
        contentView.updateCustomMealsCountLabel(with: customMealsCount)

    }
    
    private func customFoodsTapped() {
        if let tabBarVC = self.tabBarController as? MainTabBarController {
            UIView.animate(withDuration: 0.03, delay: 0.01, animations: {
                tabBarVC.trackButtonView.alpha = 0.0
            }) { _ in
                tabBarVC.trackButtonView.isHidden = true
                tabBarVC.trackButtonView.setButtonEnabled(false)
                tabBarVC.trackButtonView.shouldAcceptTouches = false
            }
        }
        
        let customFoodsVC = CustomFoodsViewController()
        customFoodsVC.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(customFoodsVC, animated: true)
    }
    
    private func customMealsTapped() {
        if let tabBarVC = self.tabBarController as? MainTabBarController {
            UIView.animate(withDuration: 0.03, delay: 0.01, animations: {
                tabBarVC.trackButtonView.alpha = 0.0
            }) { _ in
                tabBarVC.trackButtonView.isHidden = true
                tabBarVC.trackButtonView.setButtonEnabled(false)
                tabBarVC.trackButtonView.shouldAcceptTouches = false
            }
        }
        
        let customMealsVC = CustomMealsViewController()
        customMealsVC.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(customMealsVC, animated: true)
    }
}
