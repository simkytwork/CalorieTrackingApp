//
//  MealFoodSelectionView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 12/03/2024.
//

import UIKit

class MealFoodSelectionView: UIView {
    private let placeholderBackgroundView = UIView()
    private let placeholderLabel = UILabel()
    private let placeholderImageView = UIImageView()
    private let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupPlaceholderLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
        setupPlaceholderLabel()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 87
        tableView.backgroundColor = Constants.backgroundColor
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    private func setupPlaceholderLabel() {
        placeholderBackgroundView.layer.cornerRadius = 6
        placeholderBackgroundView.layer.borderColor = UIColor.systemGray5.cgColor
        placeholderBackgroundView.layer.borderWidth = 0.5
        placeholderBackgroundView.backgroundColor = Constants.mainColor
        placeholderBackgroundView.layer.masksToBounds = false
        placeholderBackgroundView.layer.shadowColor = UIColor.black.cgColor
        placeholderBackgroundView.layer.shadowOpacity = 0.05
        placeholderBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        placeholderBackgroundView.layer.shadowRadius = 1
        placeholderBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderBackgroundView)

        placeholderLabel.text = "You don't actually have any custom foods yet... Why don't you add some first?"
        placeholderLabel.textAlignment = .natural
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderBackgroundView.addSubview(placeholderLabel)

        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.contentMode = .scaleAspectFit
        placeholderImageView.image = UIImage(named: "shrug")
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
        DispatchQueue.main.async {
            self.placeholderLabel.isHidden = !show
            self.placeholderImageView.isHidden = !show
            self.placeholderBackgroundView.isHidden = !show
        }
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
