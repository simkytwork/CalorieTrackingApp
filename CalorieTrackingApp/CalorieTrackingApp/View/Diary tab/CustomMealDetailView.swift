//
//  CustomMealDetailView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 14/03/2024.
//

import UIKit

class CustomMealDetailView: UIView {
    private let stackView = UIStackView()
    private let stackBackgroundView = UIView()
    private let amountTextField = UITextField()
    private let nutritionLabel = UILabel()
    private let nutritionSummaryView = NutritionSummaryView()
    private let addMealFoodButton = UIButton(type: .system)
    var onAddMealFoodTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.backgroundColor
        setupView()
        setupNutritionalInfo()
        setupAddButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = Constants.backgroundColor
        setupView()
        setupNutritionalInfo()
        setupAddButton()
    }
    
    private func setupView() {
        stackBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackBackgroundView)
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackBackgroundView.addSubview(stackView)
        
        amountTextField.borderStyle = .none
        amountTextField.text = "1"
        amountTextField.textAlignment = .right
        amountTextField.backgroundColor = .clear
        amountTextField.returnKeyType = .done
        amountTextField.keyboardType = .decimalPad
        amountTextField.font = UIFont.systemFont(ofSize: 16)
        
        let amountView = UIView()
        amountView.translatesAutoresizingMaskIntoConstraints = false
        
        let amountLabel = UILabel()
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.text = "Amount"
        amountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        
        amountView.addSubview(amountLabel)
        amountView.addSubview(amountTextField)
        
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: amountView.leadingAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: amountView.centerYAnchor),
            
            amountTextField.leadingAnchor.constraint(equalTo: amountLabel.trailingAnchor, constant: 8),
            amountTextField.trailingAnchor.constraint(equalTo: amountView.trailingAnchor),
            amountTextField.topAnchor.constraint(equalTo: amountView.topAnchor),
            amountTextField.bottomAnchor.constraint(equalTo: amountView.bottomAnchor),
            amountTextField.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        stackView.addArrangedSubview(amountView)
        
        nutritionLabel.text = "Nutritional information"
        nutritionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nutritionLabel.textAlignment = .left
        nutritionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nutritionLabel)
        
        NSLayoutConstraint.activate([
            stackBackgroundView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            stackBackgroundView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackBackgroundView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: stackBackgroundView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: stackBackgroundView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: stackBackgroundView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: stackBackgroundView.trailingAnchor, constant: -10),
            
            nutritionLabel.topAnchor.constraint(equalTo: stackBackgroundView.bottomAnchor, constant: 30),
            nutritionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nutritionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 20),
        ])
        
        stackBackgroundView.layer.cornerRadius = 6
        stackBackgroundView.layer.borderColor = UIColor.systemGray5.cgColor
        stackBackgroundView.layer.borderWidth = 0.5
        stackBackgroundView.backgroundColor = .white
        stackBackgroundView.layer.masksToBounds = false
        stackBackgroundView.layer.shadowColor = UIColor.black.cgColor
        stackBackgroundView.layer.shadowOpacity = 0.05
        stackBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        stackBackgroundView.layer.shadowRadius = 1
    }
    
    private func setupNutritionalInfo() {
        addSubview(nutritionSummaryView)
        nutritionSummaryView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nutritionSummaryView.topAnchor.constraint(equalTo: nutritionLabel.bottomAnchor, constant: 5),
            nutritionSummaryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nutritionSummaryView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nutritionSummaryView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    private func setupAddButton() {
        addMealFoodButton.setTitle("TRACK", for: .normal)
        addMealFoodButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addMealFoodButton.backgroundColor = UIColor.systemGreen
        addMealFoodButton.setTitleColor(.white, for: .normal)
        addMealFoodButton.layer.cornerRadius = 6
        addMealFoodButton.addTarget(self, action: #selector(addMealButtonTapped), for: .touchUpInside)
        
        addMealFoodButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addMealFoodButton)
        
        NSLayoutConstraint.activate([
            addMealFoodButton.topAnchor.constraint(equalTo: nutritionSummaryView.bottomAnchor, constant: 40),
            addMealFoodButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addMealFoodButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func addMealButtonTapped() {
        onAddMealFoodTapped?()
    }
    
    func configureTextFieldChangeHandler(target: Any, action: Selector) {
        amountTextField.addTarget(target, action: action, for: .editingChanged)
    }
    
    func getAmountTextFieldText() -> String? {
        return amountTextField.text
    }
    
    func setAmountTextFieldText(to text: String) {
        amountTextField.text = text
    }
    
    func setAmountTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        amountTextField.delegate = delegate
    }
    
    func updateNutritionLabel(with details: String) {
        nutritionLabel.text = "Nutritional information per \(details)"
    }
    
    func updateNutritionSummaryInfo(kcal: Double, protein: Double, carbs: Double, fat: Double) {
        nutritionSummaryView.updateNutritionValues(kcal: kcal, protein: protein, carbs: carbs, fat: fat)
    }
}
