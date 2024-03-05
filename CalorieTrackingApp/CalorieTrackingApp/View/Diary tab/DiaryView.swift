//
//  DiaryView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 21/02/2024.
//

import UIKit

class DiaryView: UIView {
    private let dateBackgroundView = UIView()
    private let dateLabel = UILabel()
    private let leftButton = UIButton(type: .system)
    private let rightButton = UIButton(type: .system)
    private let dayNameLabel = UILabel()
    var onDateLabelTapped: (() -> Void)?
    var onIncrementDateTapped: (() -> Void)?
    var onDecrementDateTapped: (() -> Void)?
    
    private let nutritionSummaryView = NutritionSummaryView()
    
    private var mealBars: [MealBarView] = []
    var mealBarTapped: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDateLabel()
        setupDateLabelTap()
        setupButtonTargets()
        setupMealBars()
        setupNutritionalInfo()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDateLabel()
        setupDateLabelTap()
        setupButtonTargets()
        setupMealBars()
        setupNutritionalInfo()
    }
    
    private func setupDateLabel() {
        dateBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        dateBackgroundView.backgroundColor = UIColor.white
        addSubview(dateBackgroundView)
        sendSubviewToBack(dateBackgroundView)
        
        NSLayoutConstraint.activate([
            dateBackgroundView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            dateBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateBackgroundView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        dateLabel.textAlignment = .center
        dateLabel.textColor = .black
        dateLabel.font = UIFont.boldSystemFont(ofSize: 32)
        updateDateLabel(with: Date())
        
        dayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        dayNameLabel.textAlignment = .center
        dayNameLabel.textColor = .black
        dayNameLabel.font = UIFont.systemFont(ofSize: 28)
        addSubview(dayNameLabel)
        updateDayNameLabel(with: Date())
        
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
            
            dayNameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            dayNameLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            dayNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setupNutritionalInfo() {
        addSubview(nutritionSummaryView)
        nutritionSummaryView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nutritionSummaryView.topAnchor.constraint(equalTo: dayNameLabel.bottomAnchor),
            nutritionSummaryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nutritionSummaryView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupMealBars() {
        let meals = Constants.mealNames
        
        var previousMealBarBottomAnchor: NSLayoutYAxisAnchor = self.safeAreaLayoutGuide.bottomAnchor
        
        for (index, meal) in meals.enumerated().reversed() {
            let mealBar = MealBarView()
            mealBar.updateMealLabel(with: meal)
            mealBar.updateImage(with: meal)
            mealBar.updateKcalLabel(with: 0)
            mealBar.translatesAutoresizingMaskIntoConstraints = false
            addSubview(mealBar)
            mealBars.append(mealBar)
            
            mealBar.isUserInteractionEnabled = true
            mealBar.onMealBarTapped = { [weak self] in
                self?.mealBarTapped(mealBar)
            }
            
            let bottomConstraint: NSLayoutConstraint
            if index == 3 { // for the last one the spacing to the bottom of the screen needs to be larger
                bottomConstraint = mealBar.bottomAnchor.constraint(equalTo: previousMealBarBottomAnchor, constant: -30)
            } else {
                bottomConstraint = mealBar.bottomAnchor.constraint(equalTo: previousMealBarBottomAnchor, constant: 11)
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
    
    @objc private func mealBarTapped(_ mealBar: MealBarView) {
        let mealName = mealBar.getMealLabelText()
        self.mealBarTapped?(mealName)
    }
    
    func updateKcalValue(forMealName mealName: String, withKcal kcal: Int) {
        guard let index = Constants.mealNames.firstIndex(of: mealName), index < mealBars.count else { return }
        
        let mealBar = mealBars.reversed()[index]
        mealBar.updateKcalLabel(with: kcal)
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
        let calendar = Calendar.current

        let startOfToday = calendar.startOfDay(for: Date())
        let startOfProvidedDate = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfProvidedDate) // calculates the difference between the days
        
        switch components.day {
        case 0:
            dateLabel.text = "Today"
        case 1:
            dateLabel.text = "Tomorrow"
        case -1:
            dateLabel.text = "Yesterday"
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            dateLabel.text = dateFormatter.string(from: date)
        }
    }
    
    func updateDayNameLabel(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayName = dateFormatter.string(from: date)
        dayNameLabel.text = dayName
    }
    
    func updateNutritionSummaryInfo(kcal: String, protein: String, carbs: String, fat: String) {
        nutritionSummaryView.updateNutritionValues(kcal: kcal, protein: protein, carbs: carbs, fat: fat)
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
