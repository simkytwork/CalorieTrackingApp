//
//  MealView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 26/02/2024.
//

import UIKit

class MealView: UIView {
    private let nutritionSummaryView = NutritionSummaryView()
    
    private let placeholderBackgroundView = UIView()
    private let placeholderLabel = UILabel()
    private let placeholderImageView = UIImageView()
    
    let tableView = UITableView()
    private var tableViewTopConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupNutritionalInfo()
        setupPlaceholderLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
        setupNutritionalInfo()
        setupPlaceholderLabel()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1)
        tableView.separatorStyle = .none
        tableView.rowHeight = 87
        tableView.backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1)
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: topAnchor)
        
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
            tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: nutritionSummaryView.bottomAnchor, constant: 20)
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
    
    func updatePlaceholderVisibility(show: Bool) {
        placeholderLabel.isHidden = !show
        placeholderImageView.isHidden = !show
        placeholderBackgroundView.isHidden = !show
    }
    
    func updateNutritionalInfoVisibility(show: Bool) {
        nutritionSummaryView.isHidden = !show
    }
}
