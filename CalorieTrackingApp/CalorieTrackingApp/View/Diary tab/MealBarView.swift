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
    private let mealLabel = UILabel()
    private let imageView = UIImageView()
    private let kcalValueLabel = UILabel()
    private let kcalDetailLabel = UILabel()
    var onMealBarTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = Constants.mainColor
        setupView()
        setupGestureRecognizers()
    }

    private func setupView() {
        mealBarView.translatesAutoresizingMaskIntoConstraints = false
        mealBarView.isUserInteractionEnabled = true
        mealBarView.backgroundColor = .white
        addSubview(mealBarView)
        
        mealBarView.layer.shadowColor = UIColor.black.cgColor
        mealBarView.layer.shadowOffset = CGSize(width: 0, height: 2)
        mealBarView.layer.shadowOpacity = 0.06
        mealBarView.layer.shadowRadius = 6

        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        mealBarView.addSubview(imageView)
        
        labelsContainerView.translatesAutoresizingMaskIntoConstraints = false
        mealBarView.addSubview(labelsContainerView)
        
        mealLabel.text = ""
        mealLabel.font = .boldSystemFont(ofSize: 16)
        mealLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsContainerView.addSubview(mealLabel)

        kcalValueLabel.text = ""
        kcalValueLabel.font = .boldSystemFont(ofSize: 13)
        kcalValueLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsContainerView.addSubview(kcalValueLabel)
        
        kcalDetailLabel.text = "kcal"
        kcalDetailLabel.font = .systemFont(ofSize: 13)
        kcalDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsContainerView.addSubview(kcalDetailLabel)

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
            labelsContainerView.trailingAnchor.constraint(lessThanOrEqualTo: kcalValueLabel.leadingAnchor, constant: -20),
            
            mealLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor),
            mealLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor, constant: 20),
            mealLabel.bottomAnchor.constraint(equalTo: labelsContainerView.bottomAnchor),
            
            kcalValueLabel.trailingAnchor.constraint(equalTo: kcalDetailLabel.leadingAnchor, constant: -3),
            kcalValueLabel.bottomAnchor.constraint(equalTo: mealBarView.bottomAnchor, constant: -13),
            
            kcalDetailLabel.trailingAnchor.constraint(equalTo: mealBarView.trailingAnchor, constant: -26),
            kcalDetailLabel.bottomAnchor.constraint(equalTo: mealBarView.bottomAnchor, constant: -13)
        ])
    }
    
    func updateMealLabel(with text: String) {
        DispatchQueue.main.async {
            self.mealLabel.text = text
        }
    }
    
    func updateImage(with imageName: String) {
        let image = UIImage(named: imageName)
        imageView.image = image
    }
    
    func updateKcalLabel(with count: Double) {
        let kcalValue = "\(String(format: "%.0f", count))"

        DispatchQueue.main.async {
            self.kcalValueLabel.text = kcalValue
        }
    }
    
    func getMealLabelText() -> String {
        return mealLabel.text ?? ""
    }
    
    func setupGestureRecognizers() {
        let mealBarTapGesture = UITapGestureRecognizer(target: self, action: #selector(mealBarViewTapped))
        mealBarView.addGestureRecognizer(mealBarTapGesture)
    }
    
    @objc private func mealBarViewTapped() {
        onMealBarTapped?()
    }
}
