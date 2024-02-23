//
//  DiaryView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 21/02/2024.
//

import UIKit

class DiaryView: UIView {
    private let dateLabel = UILabel()
    private let leftButton = UIButton(type: .system)
    private let rightButton = UIButton(type: .system)
    var onDateLabelTapped: (() -> Void)?
    var onIncrementDateTapped: (() -> Void)?
    var onDecrementDateTapped: (() -> Void)?
    
    private var mealBars: [MealBarView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDateLabel()
        setupDateLabelTap()
        setupButtonTargets()
        setupMealBars()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDateLabel()
        setupDateLabelTap()
        setupButtonTargets()
        setupMealBars()
    }
    
    private func setupDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        dateLabel.textAlignment = .center
        dateLabel.textColor = .black
        dateLabel.font = UIFont.boldSystemFont(ofSize: 32)
        updateDateLabel(with: Date())
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.setImage(UIImage(systemName: "arrowtriangle.left.fill"), for: .normal)
        leftButton.tintColor = .black
        addSubview(leftButton)
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        rightButton.tintColor = .black
        addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            leftButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            leftButton.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -10),

            dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            
            rightButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            rightButton.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10),
        ])
    }
    
    private func setupMealBars() {
        let meals = ["Breakfast", "Lunch", "Dinner", "Snacks"]
        
        var previousMealBarBottomAnchor: NSLayoutYAxisAnchor = self.safeAreaLayoutGuide.bottomAnchor
        
        for (index, meal) in meals.enumerated().reversed() {
            let mealBar = MealBarView()
            mealBar.mealLabel.text = meal
            mealBar.updateImage(with: meal)
            mealBar.kcalLabel.text = "0 kcal"
            mealBar.translatesAutoresizingMaskIntoConstraints = false
            addSubview(mealBar)
            mealBars.append(mealBar)
            
            let bottomConstraint: NSLayoutConstraint
            if index == 3 { // for the last one the spacing to the bottom of the screen needs to be larger
                bottomConstraint = mealBar.bottomAnchor.constraint(equalTo: previousMealBarBottomAnchor, constant: -50)
            } else {
                bottomConstraint = mealBar.bottomAnchor.constraint(equalTo: previousMealBarBottomAnchor, constant: 10)
            }
            
            NSLayoutConstraint.activate([
                mealBar.leadingAnchor.constraint(equalTo: leadingAnchor),
                mealBar.trailingAnchor.constraint(equalTo: trailingAnchor),
                mealBar.heightAnchor.constraint(equalToConstant: 80),
                bottomConstraint
            ])
            
            previousMealBarBottomAnchor = mealBar.topAnchor
        }
    }
    
    private func setupDateLabelTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped))
        dateLabel.isUserInteractionEnabled = true
        dateLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setupButtonTargets() {
        leftButton.addTarget(self, action: #selector(decrementDateTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(incrementDateTapped), for: .touchUpInside)
    }
    
    func popoverSourceView() -> UIView {
        return dateLabel
    }
    
    func popoverSourceRect() -> CGRect {
        return dateLabel.bounds
    }
    
    func updateDateLabel(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    @objc private func dateLabelTapped() {
        onDateLabelTapped?()
    }
    
    @objc private func decrementDateTapped() {
        onDecrementDateTapped?()
    }
    
    @objc private func incrementDateTapped() {
        onIncrementDateTapped?()
    }
}
