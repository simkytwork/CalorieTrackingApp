//
//  MealView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 26/02/2024.
//

import UIKit

class MealView: UIView {
    let nutritionSummaryView = NutritionSummaryView()
    
    private let placeholderBackgroundView = UIView()
    private let placeholderLabel = UILabel()
    private let placeholderImageView = UIImageView()
    
    private let tableLabel = UILabel()
    private let tableView = UITableView()
    private var tableViewTopConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNutritionalInfo()
        setupTableView()
        setupPlaceholderLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNutritionalInfo()
        setupTableView()
        setupPlaceholderLabel()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        tableLabel.translatesAutoresizingMaskIntoConstraints = false
        tableLabel.text = "YOU HAVE TRACKED"
        tableLabel.font = .systemFont(ofSize: 13, weight: .bold)
        tableLabel.textColor = Constants.textColor
        addSubview(tableLabel)
        
        NSLayoutConstraint.activate([
            tableLabel.topAnchor.constraint(equalTo: nutritionSummaryView.bottomAnchor, constant: 35),
            tableLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            tableLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ])
        
        backgroundColor = Constants.backgroundColor
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 87
        tableView.backgroundColor = Constants.backgroundColor
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: tableLabel.bottomAnchor, constant: 10)

        NSLayoutConstraint.activate([
            tableViewTopConstraint!,
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    func updateTableViewTopConstraint(isSearching: Bool) {
        tableViewTopConstraint?.isActive = false
        
        if isSearching {
            tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: topAnchor)
        } else {
            tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: tableLabel.bottomAnchor, constant: 20)
        }
        
        tableViewTopConstraint?.isActive = true
        self.layoutIfNeeded()
    }
    
    private func setupNutritionalInfo() {
        addSubview(nutritionSummaryView)
        nutritionSummaryView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nutritionSummaryView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            nutritionSummaryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nutritionSummaryView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nutritionSummaryView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupPlaceholderLabel() {
        placeholderBackgroundView.layer.cornerRadius = 6
        placeholderBackgroundView.layer.borderColor = UIColor.systemGray5.cgColor
        placeholderBackgroundView.layer.borderWidth = 0.5
        placeholderBackgroundView.backgroundColor = .white
        placeholderBackgroundView.layer.masksToBounds = false
        placeholderBackgroundView.layer.shadowColor = UIColor.black.cgColor
        placeholderBackgroundView.layer.shadowOpacity = 0.05
        placeholderBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        placeholderBackgroundView.layer.shadowRadius = 1
        placeholderBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderBackgroundView)

        placeholderLabel.text = "You haven't logged any food yet... Are you sure you haven't eaten?"
        placeholderLabel.textAlignment = .natural
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderBackgroundView.addSubview(placeholderLabel)

        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.contentMode = .scaleAspectFit
        placeholderImageView.image = UIImage(named: "starvation")
        placeholderBackgroundView.addSubview(placeholderImageView)
        
        NSLayoutConstraint.activate([
            placeholderBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeholderBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            placeholderBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            placeholderImageView.leadingAnchor.constraint(equalTo: placeholderBackgroundView.leadingAnchor, constant: 15),
            placeholderImageView.centerYAnchor.constraint(equalTo: placeholderBackgroundView.centerYAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 70),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 70),
            
            placeholderLabel.leadingAnchor.constraint(equalTo: placeholderImageView.trailingAnchor, constant: 8),
            placeholderLabel.centerYAnchor.constraint(equalTo: placeholderImageView.centerYAnchor),
            placeholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: placeholderBackgroundView.trailingAnchor, constant: -20),
            placeholderBackgroundView.bottomAnchor.constraint(greaterThanOrEqualTo: placeholderLabel.bottomAnchor, constant: 20),
        ])
    }
    
    func updateTableLabelVsibility(show: Bool) {
        tableLabel.isHidden = !show
    }
    
    func updatePlaceholderVisibility(show: Bool) {
        placeholderLabel.isHidden = !show
        placeholderImageView.isHidden = !show
        placeholderBackgroundView.isHidden = !show
    }
    
    func updateNutritionalInfoVisibility(show: Bool) {
        nutritionSummaryView.isHidden = !show
    }
    
    func updateNutritionSummaryInfo(kcal: Double, protein: Double, carbs: Double, fat: Double) {
        nutritionSummaryView.updateNutritionValues(kcal: kcal, protein: protein, carbs: carbs, fat: fat)
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
    
    func showTableView(_ show: Bool) {
        tableView.isHidden = show
    }
}
