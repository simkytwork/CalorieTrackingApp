//
//  DiaryView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 21/02/2024.
//

import UIKit

class DiaryView: UIView {
    private let dateBackgroundView = UIView()
    private var calendarImage = UIImageView()
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
        dateBackgroundView.backgroundColor = Constants.mainColor
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
        dateLabel.font = UIFont.boldSystemFont(ofSize: 28)
        updateDateLabel(with: Date())
        
        let image = UIImage(named: "calendar")
        calendarImage = UIImageView(image: image!)
        calendarImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(calendarImage)
        
        dayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        dayNameLabel.textAlignment = .center
        dayNameLabel.textColor = .black
        dayNameLabel.font = UIFont.systemFont(ofSize: 24)
        addSubview(dayNameLabel)
        updateDayNameLabel(with: Date())
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        leftButton.tintColor = .black
        addSubview(leftButton)
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        rightButton.tintColor = .black
        addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            leftButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            calendarImage.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            calendarImage.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -10),
            calendarImage.heightAnchor.constraint(equalToConstant: 15),
            calendarImage.widthAnchor.constraint(equalToConstant: 15),

            
            dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            dateLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            
            rightButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            dayNameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2),
            dayNameLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            dayNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setupNutritionalInfo() {
        addSubview(nutritionSummaryView)
        nutritionSummaryView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nutritionSummaryView.topAnchor.constraint(equalTo: dayNameLabel.bottomAnchor, constant: -5),
            nutritionSummaryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nutritionSummaryView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        bringSubviewToFront(dateBackgroundView)
        bringSubviewToFront(leftButton)
        bringSubviewToFront(rightButton)
        bringSubviewToFront(dateLabel)
        bringSubviewToFront(dayNameLabel)
        bringSubviewToFront(calendarImage)
    }
    
    private func setupMealBars() {
        mealBars.forEach { $0.removeFromSuperview() } // Remove existing meal bars.
                mealBars = []
        
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
    
    func updateKcalValue(forMealName mealName: String, withKcal kcal: Double) {
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
        
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfProvidedDate)
        
        // Prepare for animation by setting initial state
        dateLabel.alpha = 0
        dateLabel.transform = CGAffineTransform(translationX: -30, y: 0)
        calendarImage.alpha = 0
        calendarImage.transform = CGAffineTransform(translationX: -30, y: 0)

        
        // Update the label text
        let newText: String = {
            switch components.day {
            case 0: return "Today"
            case 1: return "Tomorrow"
            case -1: return "Yesterday"
            default:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d"
                return dateFormatter.string(from: date)
            }
        }()
        
        // Animate label back to its original position and fade in
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.dateLabel.text = newText
            self.dateLabel.alpha = 1
            self.dateLabel.transform = .identity
            self.calendarImage.alpha = 1
            self.calendarImage.transform = .identity
        }, completion: nil)
        
        self.animateMealBarsIn(direction: .right)
    }
    
    private func animateMealBarsIn(direction: AnimationDirection) {
            let offset: CGFloat = 30
            mealBars.forEach { $0.alpha = 0 }
            mealBars.enumerated().forEach { index, bar in
                bar.transform = CGAffineTransform(translationX: direction == .left ? -offset : offset, y: 0)
                UIView.animate(withDuration: 0.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                    bar.alpha = 1
                    bar.transform = .identity
                })
            }
        }

        enum AnimationDirection {
            case left, right
        }
    
    func updateDayNameLabel(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayName = dateFormatter.string(from: date)

        // Prepare for animation by setting initial state
        dayNameLabel.alpha = 0
        dayNameLabel.transform = CGAffineTransform(translationX: -30, y: 0)
        
        // Animate label back to its original position and fade in
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.dayNameLabel.text = dayName
            self.dayNameLabel.alpha = 1
            self.dayNameLabel.transform = .identity
        }, completion: nil)
    }
    
    func updateNutritionSummaryInfo(kcal: Double, protein: Double, carbs: Double, fat: Double) {
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
