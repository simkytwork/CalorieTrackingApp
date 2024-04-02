//
//  FoodsView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 14/02/2024.
//

import UIKit

class FoodsView: UIView {
    private let customFoodsView = UIView()
    private let labelsContainerView = UIView()
    private let customFoodsLabel = UILabel()
    private let countLabel = UILabel()
    var onCustomFoodsTapped: (() -> Void)?

    private let customMealsView = UIView()
    private let customMealsLabelsContainerView = UIView()
    private let customMealsLabel = UILabel()
    private let customMealsCountLabel = UILabel()
    var onCustomMealsTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.backgroundColor
        setupView()
        setupCustomMealsView()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = Constants.backgroundColor
        setupView()
        setupCustomMealsView()
        setupGestureRecognizers()
    }

    private func setupView() {
        customFoodsView.translatesAutoresizingMaskIntoConstraints = false
        customFoodsView.isUserInteractionEnabled = true
        customFoodsView.backgroundColor = Constants.mainColor
        addSubview(customFoodsView)
        
        customFoodsView.layer.shadowColor = UIColor.black.cgColor
        customFoodsView.layer.shadowOffset = CGSize(width: 0, height: 2)
        customFoodsView.layer.shadowOpacity = 0.06
        customFoodsView.layer.shadowRadius = 5
        
        let image = UIImage(named: "banana")
        let imageView = UIImageView(image: image!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        customFoodsView.addSubview(imageView)
        
        labelsContainerView.translatesAutoresizingMaskIntoConstraints = false
        customFoodsView.addSubview(labelsContainerView)
        
        customFoodsLabel.text = "Custom Foods"
        customFoodsLabel.font = .boldSystemFont(ofSize: 16)
        customFoodsLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsContainerView.addSubview(customFoodsLabel)

        countLabel.text = "0 foods"
        countLabel.font = .systemFont(ofSize: 15)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsContainerView.addSubview(countLabel)

        NSLayoutConstraint.activate([
            customFoodsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            customFoodsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customFoodsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            customFoodsView.heightAnchor.constraint(equalToConstant: 80),
            
            imageView.leadingAnchor.constraint(equalTo: customFoodsView.leadingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: customFoodsView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            labelsContainerView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            labelsContainerView.centerYAnchor.constraint(equalTo: customFoodsView.centerYAnchor),
            labelsContainerView.trailingAnchor.constraint(lessThanOrEqualTo: customFoodsView.trailingAnchor, constant: -20),
            
            customFoodsLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor),
            customFoodsLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor, constant: 20),
            customFoodsLabel.trailingAnchor.constraint(lessThanOrEqualTo: labelsContainerView.trailingAnchor, constant: -20),
            
            countLabel.topAnchor.constraint(equalTo: customFoodsLabel.bottomAnchor, constant: 8),
            countLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor, constant: 20),
            countLabel.trailingAnchor.constraint(lessThanOrEqualTo: labelsContainerView.trailingAnchor, constant: -20),
            countLabel.bottomAnchor.constraint(equalTo: labelsContainerView.bottomAnchor)
        ])
    }
    
    private func setupCustomMealsView() {
        customMealsView.translatesAutoresizingMaskIntoConstraints = false
        customMealsView.isUserInteractionEnabled = true
        customMealsView.backgroundColor = Constants.mainColor
        addSubview(customMealsView)
        
        customMealsView.layer.shadowColor = UIColor.black.cgColor
        customMealsView.layer.shadowOffset = CGSize(width: 0, height: 2)
        customMealsView.layer.shadowOpacity = 0.06
        customMealsView.layer.shadowRadius = 5
        
        let image = UIImage(named: "custommeal")
        let imageView = UIImageView(image: image!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        customMealsView.addSubview(imageView)
        
        customMealsLabelsContainerView.translatesAutoresizingMaskIntoConstraints = false
        customMealsView.addSubview(customMealsLabelsContainerView)
        
        customMealsLabel.text = "Custom Meals"
        customMealsLabel.font = .boldSystemFont(ofSize: 16)
        customMealsLabel.translatesAutoresizingMaskIntoConstraints = false
        customMealsLabelsContainerView.addSubview(customMealsLabel)

        customMealsCountLabel.text = "0 meals"
        customMealsCountLabel.font = .systemFont(ofSize: 15)
        customMealsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        customMealsLabelsContainerView.addSubview(customMealsCountLabel)

        NSLayoutConstraint.activate([
            customMealsView.topAnchor.constraint(equalTo: customFoodsView.bottomAnchor, constant: 20),
            customMealsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customMealsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            customMealsView.heightAnchor.constraint(equalToConstant: 80),
            
            imageView.leadingAnchor.constraint(equalTo: customMealsView.leadingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: customMealsView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            customMealsLabelsContainerView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            customMealsLabelsContainerView.centerYAnchor.constraint(equalTo: customMealsView.centerYAnchor),
            customMealsLabelsContainerView.trailingAnchor.constraint(lessThanOrEqualTo: customMealsView.trailingAnchor, constant: -20),
            
            customMealsLabel.topAnchor.constraint(equalTo: customMealsLabelsContainerView.topAnchor),
            customMealsLabel.leadingAnchor.constraint(equalTo: customMealsLabelsContainerView.leadingAnchor, constant: 20),
            customMealsLabel.trailingAnchor.constraint(lessThanOrEqualTo: customMealsLabelsContainerView.trailingAnchor, constant: -20),
            
            customMealsCountLabel.topAnchor.constraint(equalTo: customMealsLabel.bottomAnchor, constant: 8),
            customMealsCountLabel.leadingAnchor.constraint(equalTo: customMealsLabelsContainerView.leadingAnchor, constant: 20),
            customMealsCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: customMealsLabelsContainerView.trailingAnchor, constant: -20),
            customMealsCountLabel.bottomAnchor.constraint(equalTo: customMealsLabelsContainerView.bottomAnchor)
        ])
    }
    
    func updateCountLabel(with count: Int) {
        DispatchQueue.main.async {
            self.countLabel.text = "\(count) foods"
        }
    }
    
    func updateCustomMealsCountLabel(with count: Int) {
        DispatchQueue.main.async {
            self.customMealsCountLabel.text = "\(count) meals"
        }
    }
    
    func setupGestureRecognizers() {
        let customFoodsTapGesture = UITapGestureRecognizer(target: self, action: #selector(customFoodsViewTapped))
        customFoodsView.addGestureRecognizer(customFoodsTapGesture)
        
        let customMealsTapGesture = UITapGestureRecognizer(target: self, action: #selector(customMealsViewTapped))
        customMealsView.addGestureRecognizer(customMealsTapGesture)
    }
    
    @objc private func customFoodsViewTapped() {
        onCustomFoodsTapped?()
    }
    
    @objc private func customMealsViewTapped() {
        onCustomMealsTapped?()
    }
}
