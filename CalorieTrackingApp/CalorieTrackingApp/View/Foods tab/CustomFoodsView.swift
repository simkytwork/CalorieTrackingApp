//
//  CustomFoodsView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 14/02/2024.
//

import UIKit

class CustomFoodsView: UIView {
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

        placeholderLabel.text = "No custom foods yet... Why don't you add some?"
        placeholderLabel.textAlignment = .natural
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderBackgroundView.addSubview(placeholderLabel)

        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.contentMode = .scaleAspectFit
        placeholderImageView.image = UIImage(named: "hungry")
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

class FoodTableViewCell: UITableViewCell {
    let stackView = UIView()
    let nameLabel = UILabel()
    let kcalLabel = UILabel()
    let kcalImageView = UIImageView()
    let servingDetailsLabel = UILabel()
    let servingDetailImageView = UIImageView()
    
    private let actionButton = UIButton(type: .system)
    private var actionButtonConstraints: [NSLayoutConstraint] = []
    var onActionButtonPressed: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupActionButton()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 6
        stackView.layer.borderColor = UIColor.systemGray6.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.backgroundColor = Constants.mainColor
        stackView.layer.masksToBounds = false
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.05
        stackView.layer.shadowOffset = CGSize(width: 0, height: 2)
        stackView.layer.shadowRadius = 2
    
        contentView.addSubview(stackView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        kcalLabel.translatesAutoresizingMaskIntoConstraints = false
        servingDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        kcalImageView.translatesAutoresizingMaskIntoConstraints = false
        servingDetailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        kcalImageView.contentMode = .scaleAspectFit
        kcalImageView.image = UIImage(named: "calories")
        
        servingDetailImageView.contentMode = .scaleAspectFit
        servingDetailImageView.image = UIImage(systemName: "pencil.and.ellipsis.rectangle")
        servingDetailImageView.tintColor = .black
        
        stackView.addSubview(kcalImageView)
        stackView.addSubview(servingDetailImageView)
        
        stackView.addSubview(nameLabel)
        stackView.addSubview(kcalLabel)
        stackView.addSubview(servingDetailsLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            nameLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -56),
            
            kcalLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            kcalLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            kcalLabel.trailingAnchor.constraint(lessThanOrEqualTo: kcalImageView.leadingAnchor, constant: -5),
            
            kcalImageView.centerYAnchor.constraint(equalTo: kcalLabel.centerYAnchor),
            kcalImageView.leadingAnchor.constraint(equalTo: kcalLabel.trailingAnchor, constant: 5),
            kcalImageView.widthAnchor.constraint(equalToConstant: 18),
            kcalImageView.heightAnchor.constraint(equalToConstant: 18),
            
            servingDetailsLabel.topAnchor.constraint(equalTo: kcalLabel.bottomAnchor, constant: 3),
            servingDetailsLabel.leadingAnchor.constraint(equalTo: servingDetailImageView.trailingAnchor, constant: 5),
            servingDetailsLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            servingDetailsLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10),
            
            servingDetailImageView.centerYAnchor.constraint(equalTo: servingDetailsLabel.centerYAnchor),
            servingDetailImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            servingDetailImageView.widthAnchor.constraint(equalToConstant: 18),
            servingDetailImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setupActionButton() {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(actionButton)
        
        actionButton.isHidden = true
        
        actionButtonConstraints = [
            actionButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            actionButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 40),
            actionButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        actionButton.frame.size = CGSize(width: 40, height: 40)
        actionButton.backgroundColor = Constants.accentColor
        actionButton.layer.cornerRadius = actionButton.frame.height / 2
        actionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        actionButton.tintColor = .white
        
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
    }
    
    @objc func actionButtonPressed() {
        onActionButtonPressed?()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        stackView.backgroundColor = highlighted ? Constants.accentColor : .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        actionButton.isHidden = true
    }
    
    func setupLocalFoodCell(with food: Food, showActionButton: Bool) {
        let mealName = food.wrappedName
        let mealText = " • Food"

        let attributedString = NSMutableAttributedString(string: mealName, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])

        let regularText = NSAttributedString(string: mealText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        attributedString.append(regularText)
        
        nameLabel.attributedText = attributedString
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        kcalLabel.text = String(format: "%.0f", food.kcal) + " kcal"
        kcalLabel.font = .systemFont(ofSize: 13)
        
        let servingText = food.serving ?? "Unknown serving"
        let perservingText = food.perserving ?? "Unknown"

        let sizeText = String(format: "%.0f", food.size)

        servingDetailsLabel.text = "1 \(servingText) (\(sizeText) \(perservingText))"
        servingDetailsLabel.font = .systemFont(ofSize: 13)
        
        actionButton.isHidden = !showActionButton
        if showActionButton {
            NSLayoutConstraint.activate(actionButtonConstraints)
        } else {
            NSLayoutConstraint.deactivate(actionButtonConstraints)
        }
        
        contentView.layoutIfNeeded()
    }
    
    func setupEdamamFoodCell(with food: EdamamItem, showActionButton: Bool) {
        let mealName = food.label
        let mealText = " • Food"

        let attributedString = NSMutableAttributedString(string: mealName, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])

        let regularText = NSAttributedString(string: mealText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        attributedString.append(regularText)

        nameLabel.attributedText = attributedString
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        kcalLabel.text = String(format: "%.0f", food.nutrients.ENERC_KCAL) + " kcal"
        kcalLabel.font = .systemFont(ofSize: 13)
        
        let servingText = "Standard serving"
        let perservingText = "g"

        let sizeText = "100"

        servingDetailsLabel.text = "1 \(servingText) (\(sizeText) \(perservingText))"
        servingDetailsLabel.font = .systemFont(ofSize: 13)
        
        actionButton.isHidden = !showActionButton
        if showActionButton {
            NSLayoutConstraint.activate(actionButtonConstraints)
        } else {
            NSLayoutConstraint.deactivate(actionButtonConstraints)
        }
        
        contentView.layoutIfNeeded()
    }
    
    func setupCustomMealCell(with customMeal: CustomMeal, showActionButton: Bool) {
        
        let mealName = customMeal.wrappedName
        let mealText = " • Meal"

        let attributedString = NSMutableAttributedString(string: mealName, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])

        let regularText = NSAttributedString(string: mealText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        attributedString.append(regularText)

        nameLabel.attributedText = attributedString
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        kcalLabel.text = String(format: "%.0f", customMeal.kcal) + " kcal"
        kcalLabel.font = .systemFont(ofSize: 13)

        let sizeText = String(format: "%.0f", customMeal.size)

        servingDetailsLabel.text = "\(sizeText) Serving"
        servingDetailsLabel.font = .systemFont(ofSize: 13)
        
        actionButton.isHidden = !showActionButton
        if showActionButton {
            NSLayoutConstraint.activate(actionButtonConstraints)
        } else {
            NSLayoutConstraint.deactivate(actionButtonConstraints)
        }
        
        contentView.layoutIfNeeded()
    }
    
    func setupFoodEntryCell(with foodEntry: FoodEntry) {
        var mealName: String = ""
        var perservingText: String = ""
        var mealText: String = ""
        
        if let food = foodEntry.food {
            mealName = food.wrappedName
            perservingText = food.wrappedPerServing
            mealText = " • Food"
        }
        else if let customMeal = foodEntry.custommeal {
            mealName = customMeal.wrappedName
            perservingText = "Serving"
            mealText = " • Meal"
        }
        
        let attributedString = NSMutableAttributedString(string: mealName, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        let regularText = NSAttributedString(string: mealText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        attributedString.append(regularText)
        
        nameLabel.attributedText = attributedString
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        kcalLabel.text = String(format: "%.0f", foodEntry.kcal) + " kcal"
        kcalLabel.font = .systemFont(ofSize: 13)
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        let sizeText = formatter.string(from: NSNumber(value: foodEntry.servingsize)) ?? "1"
        
        servingDetailsLabel.text = "\(sizeText) \(foodEntry.servingunit ?? "")"
        servingDetailsLabel.font = .systemFont(ofSize: 13)
        
        contentView.layoutIfNeeded()
    }
}
