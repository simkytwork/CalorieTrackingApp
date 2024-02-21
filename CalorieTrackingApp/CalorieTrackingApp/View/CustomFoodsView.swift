//
//  CustomFoodsView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 14/02/2024.
//

import UIKit

class CustomFoodsView: UIView {
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
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
}

class FoodTableViewCell: UITableViewCell {
    let stackView = UIView()
    let nameLabel = UILabel()
    let kcalLabel = UILabel()
    let servingDetailsLabel = UILabel()

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
        stackView.clipsToBounds = true
        stackView.layer.masksToBounds = false
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.05
        stackView.layer.shadowOffset = CGSize(width: 0, height: 1)
        stackView.layer.shadowRadius = 1
        
        contentView.addSubview(stackView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        kcalLabel.translatesAutoresizingMaskIntoConstraints = false
        servingDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            kcalLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            
            servingDetailsLabel.topAnchor.constraint(equalTo: kcalLabel.bottomAnchor, constant: 3),
            servingDetailsLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            servingDetailsLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            servingDetailsLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10)
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
