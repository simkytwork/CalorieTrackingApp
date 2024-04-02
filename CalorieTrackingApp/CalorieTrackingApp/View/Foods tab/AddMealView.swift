//
//  AddMealView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 12/03/2024.
//

import UIKit

class AddMealView: UIView {
    private let stackView = UIStackView()
    private let stackBackgroundView = UIView()
    private let nameTextField = UITextField()
    private let tableLabel = UILabel()
    private let addMealFoodButton = UIButton(type: .system)
    var onAddMealFoodTapped: (() -> Void)?
    
    private let tableView = UITableView()
    private let nutritionSummaryView = NutritionSummaryView()
    private let createMealButton = UIButton(type: .system)
    var onCreateMealTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupNutritionalInfo()
        setupCreateButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupNutritionalInfo()
        setupCreateButton()
    }
    
    private func setupView() {
        backgroundColor = Constants.backgroundColor
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 87
        tableView.layer.cornerRadius = 6
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        tableView.layer.borderWidth = 0.5
        
        stackBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackBackgroundView)
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackBackgroundView.addSubview(stackView)
        
        
        nameTextField.borderStyle = .none
        nameTextField.placeholder = "required"
        nameTextField.textAlignment = .right
        nameTextField.backgroundColor = .clear
        nameTextField.returnKeyType = .done
        nameTextField.font = UIFont.systemFont(ofSize: 16)
        
        let nameView = UIView()
        nameView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Meal name"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        nameView.addSubview(nameLabel)
        nameView.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: nameView.leadingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: nameView.centerYAnchor),
            
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            nameTextField.trailingAnchor.constraint(equalTo: nameView.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameView.topAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameView.bottomAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        stackView.addArrangedSubview(nameView)
        
        tableLabel.text = "Meal Foods"
        tableLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        tableLabel.textAlignment = .left
        tableLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableLabel)
        
        addMealFoodButton.setTitle("+ Add Meal Food", for: .normal)
        addMealFoodButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addMealFoodButton.backgroundColor = Constants.accentColor
        addMealFoodButton.setTitleColor(.white, for: .normal)
        addMealFoodButton.layer.cornerRadius = 6
        addMealFoodButton.addTarget(self, action: #selector(addMealFoodButtonTapped), for: .touchUpInside)
        
        addMealFoodButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addMealFoodButton)
        
        NSLayoutConstraint.activate([
            stackBackgroundView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            stackBackgroundView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackBackgroundView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: stackBackgroundView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: stackBackgroundView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: stackBackgroundView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: stackBackgroundView.trailingAnchor, constant: -10),
            
            tableLabel.topAnchor.constraint(equalTo: stackBackgroundView.bottomAnchor, constant: 20),
            tableLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 20),
            
            addMealFoodButton.topAnchor.constraint(equalTo: tableLabel.bottomAnchor, constant: 10),
            addMealFoodButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addMealFoodButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: addMealFoodButton.bottomAnchor, constant: 2),
            tableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -210),
            tableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -20),
        ])
        
        stackBackgroundView.layer.cornerRadius = 6
        stackBackgroundView.layer.borderColor = UIColor.systemGray5.cgColor
        stackBackgroundView.layer.borderWidth = 0.5
        stackBackgroundView.backgroundColor = Constants.mainColor
        stackBackgroundView.layer.masksToBounds = false
        stackBackgroundView.layer.shadowColor = UIColor.black.cgColor
        stackBackgroundView.layer.shadowOpacity = 0.05
        stackBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        stackBackgroundView.layer.shadowRadius = 2
        
        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.06
        tableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        tableView.layer.shadowRadius = 2 
    }
    
    private func setupNutritionalInfo() {
        addSubview(nutritionSummaryView)
        nutritionSummaryView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nutritionSummaryView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 5),
            nutritionSummaryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nutritionSummaryView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nutritionSummaryView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    private func setupCreateButton() {
        createMealButton.setTitle("CREATE MEAL", for: .normal)
        createMealButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        createMealButton.backgroundColor = UIColor.systemGreen
        createMealButton.setTitleColor(.white, for: .normal)
        createMealButton.layer.cornerRadius = 6
        createMealButton.addTarget(self, action: #selector(createMealButtonTapped), for: .touchUpInside)
        
        createMealButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(createMealButton)
        
        NSLayoutConstraint.activate([
            createMealButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createMealButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createMealButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createMealButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func updateNutritionSummaryInfo(kcal: Double, protein: Double, carbs: Double, fat: Double) {
        nutritionSummaryView.updateNutritionValues(kcal: kcal, protein: protein, carbs: carbs, fat: fat)
    }
    
    @objc private func addMealFoodButtonTapped() {
        onAddMealFoodTapped?()
    }
    
    @objc private func createMealButtonTapped() {
        onCreateMealTapped?()
    }
    
    func getNameFieldText() -> String? {
        return nameTextField.text
    }
    
    func reloadTableViewData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }

    func setTableViewDataSource(_ dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }

    func registerTableViewCell(cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        tableView.register(cellClass, forCellReuseIdentifier: identifier)
    }
}
