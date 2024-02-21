//
//  TrackButtonView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 14/02/2024.
//

import UIKit

class TrackButtonView: UIView {

    private let trackButton = UIButton()
    private let trackButtonBackgroundView = UIView()
    var shouldAcceptTouches = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupTrackButtonBackground()
        setupTrackButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTrackButton() {
        trackButton.frame.size = CGSize(width: 65, height: 65)
        trackButton.backgroundColor = .systemOrange
        trackButton.layer.cornerRadius = trackButton.frame.height / 2
        trackButton.setImage(UIImage(systemName: "plus"), for: .normal)
        trackButton.tintColor = .white
        trackButton.center = CGPoint(x: bounds.midX, y: bounds.midY)
        addSubview(trackButton)
    }
    
    private func setupTrackButtonBackground() {
        trackButtonBackgroundView.frame.size = CGSize(width: 75, height: 75)
        trackButtonBackgroundView.backgroundColor = .white
        // trackButtonBackgroundView.layer.cornerRadius = trackButtonBackgroundView.frame.height / 2
        trackButtonBackgroundView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let path = UIBezierPath(arcCenter: CGPoint(x: trackButtonBackgroundView.frame.width / 2, y: trackButtonBackgroundView.frame.height / 2), radius: trackButtonBackgroundView.frame.height / 2, startAngle: -(.pi), endAngle: 0, clockwise: true)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        trackButtonBackgroundView.layer.mask = maskLayer
        
        addSubview(trackButtonBackgroundView)
    }
    
    func setTrackButtonAction(_ target: Any?, action: Selector, for event: UIControl.Event) {
        trackButton.addTarget(target, action: action, for: event)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convertedPoint = trackButton.convert(point, from: self)
        if trackButton.bounds.contains(convertedPoint) {
            return trackButton
        }
        return nil
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return shouldAcceptTouches && super.point(inside: point, with: event)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
