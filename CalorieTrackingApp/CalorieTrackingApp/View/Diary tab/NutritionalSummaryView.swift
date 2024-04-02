//
//  NutritionalSummaryView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 26/02/2024.
//

import UIKit

class NutritionSummaryView: UIView {
    private let nutritionContainerView = UIView()
    private let summaryCircleView = PieChartView()
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
        nutritionContainerView.backgroundColor = Constants.mainColor
        addSubview(nutritionContainerView)
        
        nutritionContainerView.layer.shadowColor = UIColor.black.cgColor
        nutritionContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        nutritionContainerView.layer.shadowOpacity = 0.06
        nutritionContainerView.layer.shadowRadius = 5
        
        let circleDiameter: CGFloat = 80
        summaryCircleView.translatesAutoresizingMaskIntoConstraints = false
//        summaryCircleView.layer.borderWidth = 5
//        summaryCircleView.layer.borderColor = UIColor.systemGray4.cgColor
//        summaryCircleView.layer.cornerRadius = circleDiameter / 2
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

            kcalDetailLabel.topAnchor.constraint(equalTo: kcalValueLabel.bottomAnchor, constant: 2),
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
        proteinValueLabel.font = .boldSystemFont(ofSize: 12)
        
        carbsLabel.translatesAutoresizingMaskIntoConstraints = false
        carbsLabel.text = "Carbs "
        carbsLabel.font = .boldSystemFont(ofSize: 13)
        carbsLabel.textColor = .systemBlue
        carbsValueLabel.text = "(0%) - 0g"
        carbsValueLabel.translatesAutoresizingMaskIntoConstraints = false
        carbsValueLabel.font = .boldSystemFont(ofSize: 12)
        
        fatLabel.translatesAutoresizingMaskIntoConstraints = false
        fatLabel.text = "Fat "
        fatLabel.font = .boldSystemFont(ofSize: 13)
        fatLabel.textColor = .systemRed
        fatValueLabel.text = "(0%) - 0g"
        fatValueLabel.translatesAutoresizingMaskIntoConstraints = false
        fatValueLabel.font = .boldSystemFont(ofSize: 12)
        
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
    
    func updateNutritionValues(kcal: Double, protein: Double, carbs: Double, fat: Double) {
        DispatchQueue.main.async {
            
            let totalWeight = protein + carbs + fat
            let proteinPercentage = totalWeight > 0.01 ? (protein / totalWeight) * 100 : 0
            let carbsPercentage = totalWeight > 0.01 ? (carbs / totalWeight) * 100 : 0
            let fatPercentage = totalWeight > 0.01 ? (fat / totalWeight) * 100 : 0
            
            let proteinValue = "(\(String(format: "%.1f", proteinPercentage))%) - \(String(format: "%.1f", protein))g"
            let carbsValue = "(\(String(format: "%.1f", carbsPercentage))%) - \(String(format: "%.1f", carbs))g"
            let fatValue = "(\(String(format: "%.1f", fatPercentage))%) - \(String(format: "%.1f", fat))g"
            
            
                self.kcalValueLabel.text = String(format: "%.0f", kcal)
            self.proteinValueLabel.text = proteinValue
            self.carbsValueLabel.text = carbsValue
            self.fatValueLabel.text = fatValue
            let proteinPercentageChart = CGFloat(proteinPercentage)
            let carbsPercentageChart = CGFloat(carbsPercentage)
            let fatPercentageChart = CGFloat(fatPercentage)
                
                self.summaryCircleView.update(percentages: (protein: proteinPercentageChart, carbs: carbsPercentageChart, fat: fatPercentageChart))
            }
    }
}

class PieChartView: UIView {
    var proteinPercentage: CGFloat = 0
    var carbsPercentage: CGFloat = 0
    var fatPercentage: CGFloat = 0
    private let startAngle = -CGFloat.pi / 2
    private var proteinLayer = SegmentLayer()
    private var carbsLayer = SegmentLayer()
    private var fatLayer = SegmentLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        layer.addSublayer(proteinLayer)
        layer.addSublayer(carbsLayer)
        layer.addSublayer(fatLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        proteinLayer.frame = bounds
        carbsLayer.frame = bounds
        fatLayer.frame = bounds
    }
    
    func update(percentages: (protein: CGFloat, carbs: CGFloat, fat: CGFloat)) {
        self.proteinPercentage = percentages.protein
        self.carbsPercentage = percentages.carbs
        self.fatPercentage = percentages.fat

        drawPieChart()
    }

    private func animateSegment(layer: SegmentLayer, percentage: CGFloat, color: UIColor, startAngle: CGFloat) {
        layer.animateSegment(in: self.bounds, percentage: percentage, color: color, startAngle: startAngle, strokeWidth: 8)
    }
    
    private func drawPieChart() {
            let threshold: CGFloat = 4
            var adjustments = 0.0
            let smallSegments = [proteinPercentage, carbsPercentage, fatPercentage].filter { $0 < threshold && $0 > 0 }
            if !smallSegments.isEmpty {
                adjustments = threshold - smallSegments.min()!
            }

            var largestValue = max(proteinPercentage, carbsPercentage, fatPercentage)
            
            if adjustments > 0 {
                if proteinPercentage == largestValue {
                    proteinPercentage -= adjustments
                } else if carbsPercentage == largestValue {
                    carbsPercentage -= adjustments
                } else if fatPercentage == largestValue {
                    fatPercentage -= adjustments
                }

                if proteinPercentage < threshold && proteinPercentage > 0 { proteinPercentage = threshold }
                else if carbsPercentage < threshold && carbsPercentage > 0 { carbsPercentage = threshold }
                else if fatPercentage < threshold && fatPercentage > 0 { fatPercentage = threshold }
            }
        
            let totalPercentage = proteinPercentage + carbsPercentage + fatPercentage

            layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })

            if totalPercentage == 0 {
                drawEmptyCircle()
            } else {
                layer.addSublayer(proteinLayer)
                layer.addSublayer(carbsLayer)
                layer.addSublayer(fatLayer)

                animateSegment(layer: proteinLayer, percentage: proteinPercentage, color: .systemGreen, startAngle: startAngle)
                animateSegment(layer: carbsLayer, percentage: carbsPercentage, color: .systemBlue, startAngle: proteinLayer.endAngle)
                animateSegment(layer: fatLayer, percentage: fatPercentage, color: .systemRed, startAngle: carbsLayer.endAngle)
            }
        }

    private func drawEmptyCircle() {
            proteinLayer.removeFromSuperlayer()
            carbsLayer.removeFromSuperlayer()
            fatLayer.removeFromSuperlayer()

            let emptyCircleLayer = CAShapeLayer()
            let center = CGPoint(x: bounds.midX, y: bounds.midY)
            let radius = min(bounds.width, bounds.height) / 2 - 4
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: startAngle + 2 * .pi, clockwise: true)
            emptyCircleLayer.path = path.cgPath
            emptyCircleLayer.fillColor = nil
            emptyCircleLayer.strokeColor = Constants.backgroundColor.cgColor
            emptyCircleLayer.lineWidth = 8
            emptyCircleLayer.lineCap = .round

            layer.addSublayer(emptyCircleLayer)
        }
}

class SegmentLayer: CAShapeLayer {
    var endAngle: CGFloat = -CGFloat.pi / 2

    func animateSegment(in rect: CGRect, percentage: CGFloat, color: UIColor, startAngle: CGFloat, strokeWidth: CGFloat) {
        let gapAngle = 0.24
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - strokeWidth / 2

        let rawEndAngle = startAngle + 2 * .pi * (percentage / 100)

        let visibleSegmentEndAngle = max(startAngle, rawEndAngle - gapAngle)

        if rawEndAngle - startAngle > gapAngle {
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: visibleSegmentEndAngle, clockwise: true)
            self.path = path.cgPath
            self.fillColor = nil
            self.strokeColor = color.cgColor
            self.lineWidth = strokeWidth
            self.lineCap = .round

            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 0.6
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            self.add(animation, forKey: "strokeEnd")

            self.endAngle = rawEndAngle
        }
    }
}
