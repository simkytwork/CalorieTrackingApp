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
            UIView.animate(withDuration: 0.1, delay: 0.02) {
                tabBarVC.trackButtonView.isHidden = false
                tabBarVC.trackButtonView.alpha = 1.0
            }
        }
        fetchFoods()
    }
    
    private func setupFoodsView() {
        self.navigationItem.title = "Foods"
        view.backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1)
        
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
    }
    
    private func fetchFoods() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<Food>(entityName: "Food")
        fetchRequest.predicate = NSPredicate(format: "wasDeleted == FALSE AND isFromDatabase == FALSE")
        
        do {
            let count = try context.count(for: fetchRequest)
            DispatchQueue.main.async {
                self.updateUI(with: count)
            }
        } catch {
            print("Failed to fetch foods: \(error)")
        }
    }
    
    private func updateUI(with count: Int) {
        contentView.updateCountLabel(with: count)
    }
    
    private func customFoodsTapped() {
        if let tabBarVC = self.tabBarController as? MainTabBarController {
            UIView.animate(withDuration: 0.03, delay: 0.01, animations: {
                tabBarVC.trackButtonView.alpha = 0.0
            }) { _ in
                tabBarVC.trackButtonView.isHidden = true
            }
        }
        
        let customFoodsVC = CustomFoodsViewController()
        customFoodsVC.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(customFoodsVC, animated: true)
    }
}
