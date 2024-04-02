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
        trackButtonBackgroundView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let path = UIBezierPath(arcCenter: CGPoint(x: trackButtonBackgroundView.frame.width / 2, y: trackButtonBackgroundView.frame.height / 2), radius: trackButtonBackgroundView.frame.height / 2, startAngle: -(.pi), endAngle: 0, clockwise: true)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        trackButtonBackgroundView.layer.mask = maskLayer
        
        addSubview(trackButtonBackgroundView)
    }
    
    func configureMenu(_ menu: UIMenu) {
        trackButton.menu = menu
        trackButton.showsMenuAsPrimaryAction = true
    }
    
    func setTrackButtonAction(_ target: Any?, action: Selector, for event: UIControl.Event) {
        trackButton.addTarget(target, action: action, for: event)
    }
    
    func setButtonEnabled(_ isEnabled: Bool) {
        trackButton.isEnabled = isEnabled
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard shouldAcceptTouches else { return nil }
        let convertedPoint = trackButton.convert(point, from: self)
        if trackButton.bounds.contains(convertedPoint) && trackButton.isEnabled {
            return trackButton
        }
        return nil
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard shouldAcceptTouches else { return false }
        return super.point(inside: point, with: event)
    }
}
