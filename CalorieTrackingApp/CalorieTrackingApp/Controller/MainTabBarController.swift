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
    }
    
    @objc func trackButtonTapped() {
        print("clicked")
    }
    
    private func setupViewControllers() {
        let diaryVC = DiaryViewController()
        diaryVC.tabBarItem = UITabBarItem(title: "Diary", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book"))
        
        let foodsVC = FoodsViewController()
        foodsVC.tabBarItem = UITabBarItem(title: "Foods", image: UIImage(systemName: "fork.knife"), selectedImage: UIImage(systemName: "fork.knife"))
        
        let foodsNavController = UINavigationController(rootViewController: foodsVC)
        
        self.viewControllers = [diaryVC, foodsNavController]
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
