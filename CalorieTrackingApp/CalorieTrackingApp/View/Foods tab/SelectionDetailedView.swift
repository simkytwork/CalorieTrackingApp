//
//  SelectionDetailedView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 12/03/2024.
//

import UIKit

class SelectionDetailedView: UIView {
    private let stackView = UIStackView()
    private let stackBackgroundView = UIView()
    private let amountTextField = UITextField()
    private let servingTypeButton = UIButton(primaryAction: nil)
    var onServingTypeSelected: ((_ selectedContent: String) -> Void)?
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
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Serving Type"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        servingTypeButton.translatesAutoresizingMaskIntoConstraints = false
        servingTypeButton.contentHorizontalAlignment = .right
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.down")
        config.imagePlacement = .trailing
        config.imagePadding = 6
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 16)
            return outgoing
        }
        servingTypeButton.configuration = config
        
        view.addSubview(label)
        view.addSubview(servingTypeButton)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            servingTypeButton.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            servingTypeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 15),
            servingTypeButton.topAnchor.constraint(equalTo: view.topAnchor),
            servingTypeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(view)
        
        servingTypeButton.setTitle("Standard serving", for: .normal)
        servingTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: 5)
        servingTypeButton.tintColor = UIColor.black
        let defaultMenu = UIMenu(title: "", children: [])
        servingTypeButton.menu = defaultMenu
        servingTypeButton.showsMenuAsPrimaryAction = true
        
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
        addMealFoodButton.setTitle("ADD TO MEAL", for: .normal)
        addMealFoodButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addMealFoodButton.backgroundColor = UIColor.systemOrange
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
    
    func configureServingTypeMenu(withOptions options: [String]) {
        configureMenu(for: servingTypeButton, withOptions: options, selectionHandler: { selectedTitle in
            self.onServingTypeSelected?(selectedTitle)
        })
    }
    
    private func configureMenu(for button: UIButton, withOptions options: [String], selectionHandler: @escaping (String) -> Void) {
        let actionClosure = { (action: UIAction) in
            button.setTitle(action.title, for: .normal)
            button.tintColor = UIColor.black
            selectionHandler(action.title)
        }
        
        let menuChildren = options.map { option in
            UIAction(title: option, handler: actionClosure)
        }
        
        button.menu = UIMenu(options: .displayInline, children: menuChildren)
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .systemGray5
        
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return separator
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
    
    func setServingType(to text: String) {
        servingTypeButton.setTitle(text, for: .normal)
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
