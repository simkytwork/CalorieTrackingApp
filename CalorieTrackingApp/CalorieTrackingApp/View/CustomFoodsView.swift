//
//  CustomFoodsView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 14/02/2024.
//

import UIKit

class CustomFoodsView: UIView {
    let placeholderBackgroundView = UIView()
    let placeholderLabel = UILabel()
    let placeholderImageView = UIImageView()
    let tableView = UITableView()
    
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
        tableView.rowHeight = 87
        tableView.backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1)
        
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
        placeholderBackgroundView.backgroundColor = .white
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
        placeholderLabel.isHidden = !show
        placeholderImageView.isHidden = !show
        placeholderBackgroundView.isHidden = !show
    }
}

class FoodTableViewCell: UITableViewCell {
    let stackView = UIView()
    let nameLabel = UILabel()
    let kcalLabel = UILabel()
    let kcalImageView = UIImageView()
    let servingDetailsLabel = UILabel()
    let servingDetailImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
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
        stackView.backgroundColor = .white
        stackView.layer.masksToBounds = false
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.05
        stackView.layer.shadowOffset = CGSize(width: 0, height: 1)
        stackView.layer.shadowRadius = 1
        
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
            nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            
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
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        stackView.backgroundColor = highlighted ? UIColor.systemOrange : .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(with food: Food) {
        nameLabel.text = food.name
        nameLabel.font = .boldSystemFont(ofSize: 15)
        
        kcalLabel.text = String(format: "%.0f", food.kcal) + " kcal"
        kcalLabel.font = .systemFont(ofSize: 13)
        
        let servingText = food.serving ?? "Unknown serving"
        let perservingText = food.perserving ?? "Unknown"

        let sizeText = String(format: "%.0f", food.size)

        servingDetailsLabel.text = "1 \(servingText) (\(sizeText) \(perservingText))"
        servingDetailsLabel.font = .systemFont(ofSize: 13)
    }
}
