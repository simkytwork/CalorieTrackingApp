//
//  NutritionalSummaryView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 26/02/2024.
//

import UIKit

class NutritionSummaryView: UIView {
    private let nutritionContainerView = UIView()
    private let summaryCircleView = UIView()
    private let kcalValueLabel = UILabel()
    private let kcalDetailLabel = UILabel()
    private let proteinLabel = UILabel()
    private let proteinValueLabel = UILabel()
    private let carbsLabel = UILabel()
    private let carbsValueLabel = UILabel()
    private let fatLabel = UILabel()
    private let fatValueLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        nutritionContainerView.translatesAutoresizingMaskIntoConstraints = false
        nutritionContainerView.backgroundColor = UIColor.white
        addSubview(nutritionContainerView)
        
        let circleDiameter: CGFloat = 80
        summaryCircleView.translatesAutoresizingMaskIntoConstraints = false
        summaryCircleView.layer.borderWidth = 5
        summaryCircleView.layer.borderColor = UIColor.systemGray4.cgColor
        summaryCircleView.layer.cornerRadius = circleDiameter / 2
        summaryCircleView.backgroundColor = .clear
        nutritionContainerView.addSubview(summaryCircleView)
        
        let kcalLabelsContainerView = UIView()
        kcalLabelsContainerView.translatesAutoresizingMaskIntoConstraints = false
        summaryCircleView.addSubview(kcalLabelsContainerView)
        
        kcalValueLabel.translatesAutoresizingMaskIntoConstraints = false
        kcalValueLabel.text = "0"
        kcalValueLabel.font = .boldSystemFont(ofSize: 13)
        kcalValueLabel.textAlignment = .center
        
        kcalDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        kcalDetailLabel.text = "kcal"
        kcalDetailLabel.font = .systemFont(ofSize: 13)
        kcalDetailLabel.textAlignment = .center
        
        kcalLabelsContainerView.addSubview(kcalValueLabel)
        kcalLabelsContainerView.addSubview(kcalDetailLabel)
        
        NSLayoutConstraint.activate([
            kcalLabelsContainerView.centerXAnchor.constraint(equalTo: summaryCircleView.centerXAnchor),
            kcalLabelsContainerView.centerYAnchor.constraint(equalTo: summaryCircleView.centerYAnchor),
            kcalLabelsContainerView.widthAnchor.constraint(lessThanOrEqualTo: summaryCircleView.widthAnchor, constant: -4),
            kcalLabelsContainerView.heightAnchor.constraint(lessThanOrEqualTo: summaryCircleView.heightAnchor, constant: -4),

            kcalValueLabel.topAnchor.constraint(equalTo: kcalLabelsContainerView.topAnchor),
            kcalValueLabel.centerXAnchor.constraint(equalTo: kcalLabelsContainerView.centerXAnchor),

            kcalDetailLabel.topAnchor.constraint(equalTo: kcalValueLabel.bottomAnchor, constant: 4),
            kcalDetailLabel.centerXAnchor.constraint(equalTo: kcalLabelsContainerView.centerXAnchor),
            kcalDetailLabel.bottomAnchor.constraint(equalTo: kcalLabelsContainerView.bottomAnchor),
        ])
        
        summaryCircleView.addSubview(kcalLabelsContainerView)

        proteinLabel.translatesAutoresizingMaskIntoConstraints = false
        proteinLabel.text = "Protein "
        proteinLabel.font = .boldSystemFont(ofSize: 13)
        proteinLabel.textColor = .systemGreen
        proteinValueLabel.text = "(0%) - 0g"
        proteinValueLabel.translatesAutoresizingMaskIntoConstraints = false
        proteinValueLabel.font = .boldSystemFont(ofSize: 13)
        
        carbsLabel.translatesAutoresizingMaskIntoConstraints = false
        carbsLabel.text = "Carbs "
        carbsLabel.font = .boldSystemFont(ofSize: 13)
        carbsLabel.textColor = .systemBlue
        carbsValueLabel.text = "(0%) - 0g"
        carbsValueLabel.translatesAutoresizingMaskIntoConstraints = false
        carbsValueLabel.font = .boldSystemFont(ofSize: 13)
        
        fatLabel.translatesAutoresizingMaskIntoConstraints = false
        fatLabel.text = "Fat "
        fatLabel.font = .boldSystemFont(ofSize: 13)
        fatLabel.textColor = .systemRed
        fatValueLabel.text = "(0%) - 0g"
        fatValueLabel.translatesAutoresizingMaskIntoConstraints = false
        fatValueLabel.font = .boldSystemFont(ofSize: 13)
        
        nutritionContainerView.addSubview(proteinLabel)
        nutritionContainerView.addSubview(proteinValueLabel)
        nutritionContainerView.addSubview(carbsLabel)
        nutritionContainerView.addSubview(carbsValueLabel)
        nutritionContainerView.addSubview(fatLabel)
        nutritionContainerView.addSubview(fatValueLabel)

        NSLayoutConstraint.activate([
            nutritionContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nutritionContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nutritionContainerView.heightAnchor.constraint(equalToConstant: 120),
            
            summaryCircleView.centerYAnchor.constraint(equalTo: nutritionContainerView.centerYAnchor),
            summaryCircleView.leadingAnchor.constraint(equalTo: nutritionContainerView.leadingAnchor, constant: 45),
            summaryCircleView.widthAnchor.constraint(equalToConstant: circleDiameter),
            summaryCircleView.heightAnchor.constraint(equalToConstant: circleDiameter),
            
            proteinLabel.leadingAnchor.constraint(equalTo: summaryCircleView.trailingAnchor, constant: 20),
            proteinLabel.bottomAnchor.constraint(equalTo: carbsLabel.topAnchor, constant: -8),
            
            proteinValueLabel.leadingAnchor.constraint(equalTo: proteinLabel.trailingAnchor, constant: 4),
            proteinValueLabel.centerYAnchor.constraint(equalTo: proteinLabel.centerYAnchor),
            
            carbsLabel.leadingAnchor.constraint(equalTo: summaryCircleView.trailingAnchor, constant: 20),
            carbsLabel.centerYAnchor.constraint(equalTo: summaryCircleView.centerYAnchor),
            
            carbsValueLabel.leadingAnchor.constraint(equalTo: carbsLabel.trailingAnchor),
            carbsValueLabel.centerYAnchor.constraint(equalTo: carbsLabel.centerYAnchor),
            
            fatLabel.topAnchor.constraint(equalTo: carbsLabel.bottomAnchor, constant: 8),
            fatLabel.leadingAnchor.constraint(equalTo: summaryCircleView.trailingAnchor, constant: 20),
            
            fatValueLabel.leadingAnchor.constraint(equalTo: fatLabel.trailingAnchor, constant: 4),
            fatValueLabel.centerYAnchor.constraint(equalTo: fatLabel.centerYAnchor),
        ])
    }
    
    func updateNutritionValues(kcal: String, protein: String, carbs: String, fat: String) {
        kcalValueLabel.text = kcal
        proteinValueLabel.text = protein
        carbsValueLabel.text = carbs
        fatValueLabel.text = fat
    }
}
