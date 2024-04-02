//
//  MainTabBarController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 13/02/2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    let trackButtonView = TrackButtonView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        trackButtonView.setTrackButtonAction(self, action: #selector(trackButtonTapped), for: .touchUpInside)
        setupMenuActions()
    }
    
    @objc func trackButtonTapped() {
    }
    
    private func handleTrackAction() {
        let mealName = determineMealName()
        let selectedDate = Date()

        guard let meal = MealManager.shared.fetchOrCreateMeal(name: mealName, date: selectedDate) else { return }
        
        guard let diaryNavController = self.viewControllers?.first as? UINavigationController else { return }
        self.selectedIndex = 0

        let mealViewController = MealViewController(meal: meal)
        mealViewController.activateSearch()

        if let topMealViewController = diaryNavController.topViewController as? MealViewController {
            if topMealViewController.getMeal() != meal {
                var viewControllers = diaryNavController.viewControllers
                viewControllers.removeLast()
                viewControllers.append(mealViewController)
                diaryNavController.setViewControllers(viewControllers, animated: true)
            } else {
                topMealViewController.activateSearch()
            }
        } else {
            diaryNavController.pushViewController(mealViewController, animated: true)
        }
    }
    
    private func handleAddFoodAction() {
        let addFoodVC = AddFoodViewController()
        let navController = UINavigationController(rootViewController: addFoodVC)
        navController.modalPresentationStyle = .fullScreen
        
        self.present(navController, animated: true, completion: nil)
    }
    
    private func setupViewControllers() {
        let diaryVC = DiaryViewController()
        diaryVC.tabBarItem = UITabBarItem(title: "Diary", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book"))
        
        let diaryNavController = UINavigationController(rootViewController: diaryVC)
        
        let foodsVC = FoodsViewController()
        foodsVC.tabBarItem = UITabBarItem(title: "Foods", image: UIImage(systemName: "fork.knife"), selectedImage: UIImage(systemName: "fork.knife"))
        
        let foodsNavController = UINavigationController(rootViewController: foodsVC)
        
        self.viewControllers = [diaryNavController, foodsNavController]
        
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.tabBar.layer.shadowOpacity = 0.1
        self.tabBar.layer.shadowRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ensureTrackButtonIsOnTop()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTrackButtonPosition()
        ensureTrackButtonIsOnTop()
    }

    private func setupMenuActions() {
        let trackItem = UIAction(title: "Track Food", image: UIImage(named: "apple")) { [weak self] _ in
            self?.handleTrackAction()
        }  
        
        let addFoodItem = UIAction(title: "Add Food", image: UIImage(systemName: "plus.circle")) { [weak self] _ in
            self?.handleAddFoodAction()
        }
    
        
        let menu = UIMenu(options: .displayInline, children: [addFoodItem, trackItem])
        trackButtonView.configureMenu(menu)
    }
    
    func determineMealName() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5...10:
            // 5 AM to 10:59 AM
            return "Breakfast"
        case 11...16:
            // 11 AM to 4:59 PM
            return "Lunch"
        default:
            // 5 PM to 4:59 AM
            return "Dinner"
        }
    }
    
    func ensureTrackButtonIsOnTop() {
        // if the track button hasn't been added yet, add it
        if !trackButtonView.isDescendant(of: view) {
            view.addSubview(trackButtonView)
        }
        view.bringSubviewToFront(trackButtonView) // brings the track button to the front of the tab bar
    }

    func adjustTrackButtonPosition() {
        let trackButtonCenterX = tabBar.bounds.midX
        let trackButtonCenterY = tabBar.frame.minY - trackButtonView.bounds.height / 2
        trackButtonView.center = CGPoint(x: trackButtonCenterX, y: trackButtonCenterY)
    }
}
