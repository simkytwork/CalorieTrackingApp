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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1)
        setupView()
        setupGestureRecognizers()
    }

    private func setupView() {
        customFoodsView.translatesAutoresizingMaskIntoConstraints = false
        customFoodsView.isUserInteractionEnabled = true
        customFoodsView.backgroundColor = .white
        addSubview(customFoodsView)
        
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
    
    func updateCountLabel(with count: Int) {
        DispatchQueue.main.async {
            self.countLabel.text = "\(count) foods"
        }
    }
    
    func setupGestureRecognizers() {
        let customFoodsTapGesture = UITapGestureRecognizer(target: self, action: #selector(customFoodsViewTapped))
        customFoodsView.addGestureRecognizer(customFoodsTapGesture)
        
        // for later when custom meals will be implemented
//        let customMealsTapGesture = UITapGestureRecognizer(target: self, action: #selector(customMealsViewTapped))
//        customMealsView.addGestureRecognizer(customMealsTapGesture)
    }
    
    @objc private func customFoodsViewTapped() {
        onCustomFoodsTapped?()
    }
}
