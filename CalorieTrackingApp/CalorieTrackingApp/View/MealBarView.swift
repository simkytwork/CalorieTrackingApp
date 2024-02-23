//
//  MealView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 22/02/2024.
//

import UIKit

class MealBarView: UIView {
    private let mealBarView = UIView()
    private let labelsContainerView = UIView()
    let mealLabel = UILabel()
    private let imageView = UIImageView()
    let kcalLabel = UILabel()
    var onMealBarTapped: (() -> Void)?

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
        mealBarView.translatesAutoresizingMaskIntoConstraints = false
        mealBarView.isUserInteractionEnabled = true
        mealBarView.backgroundColor = .white
        addSubview(mealBarView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        mealBarView.addSubview(imageView)
        
        labelsContainerView.translatesAutoresizingMaskIntoConstraints = false
        mealBarView.addSubview(labelsContainerView)
        
        mealLabel.text = ""
        mealLabel.font = .boldSystemFont(ofSize: 16)
        mealLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsContainerView.addSubview(mealLabel)

        kcalLabel.text = ""
        kcalLabel.font = .systemFont(ofSize: 13)
        kcalLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsContainerView.addSubview(kcalLabel)

        NSLayoutConstraint.activate([
            mealBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mealBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mealBarView.heightAnchor.constraint(equalToConstant: 60),
            
            imageView.leadingAnchor.constraint(equalTo: mealBarView.leadingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: mealBarView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            
            labelsContainerView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            labelsContainerView.centerYAnchor.constraint(equalTo: mealBarView.centerYAnchor),
            labelsContainerView.trailingAnchor.constraint(lessThanOrEqualTo: kcalLabel.leadingAnchor, constant: -20),
            
            mealLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor),
            mealLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor, constant: 20),
            mealLabel.bottomAnchor.constraint(equalTo: labelsContainerView.bottomAnchor),
            
            kcalLabel.trailingAnchor.constraint(equalTo: mealBarView.trailingAnchor, constant: -26),
            kcalLabel.centerYAnchor.constraint(equalTo: mealBarView.centerYAnchor)
        ])
    }
    
    func updateImage(with imageName: String) {
        let image = UIImage(named: imageName)
        imageView.image = image
    }
    
    func updateKcalLabel(with count: Int) {
        DispatchQueue.main.async {
            self.kcalLabel.text = "\(count)"
        }
    }
    
    func setupGestureRecognizers() {
        let mealBarTapGesture = UITapGestureRecognizer(target: self, action: #selector(mealBarViewTapped))
        mealBarView.addGestureRecognizer(mealBarTapGesture)
    }
    
    @objc private func mealBarViewTapped() {
        onMealBarTapped?()
    }
}
