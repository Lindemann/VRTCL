//
//  PieChartView.swift
//  VRTCL
//
//  Created by Lindemann on 22.08.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class PieChartView: UIView {
    
    let percentage: Double!
    let text: String!
    let color: UIColor!
    
    let size: CGFloat = 150
    let radius: CGFloat = 40
    let lineWidth: CGFloat = 14
    
    init(percentage: Double, text: String, color: UIColor) {
        self.percentage = percentage
        self.text = text
        self.color = color
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        let containerViewSize = (radius + lineWidth / 2) * 2
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerViewSize, height: containerViewSize))
        addSubview(containerView)
        
        // Background Circle
        let backgroundCirclePath = UIBezierPath(arcCenter: containerView.center, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let backgroundShapeLayer = CAShapeLayer()
        backgroundShapeLayer.path = backgroundCirclePath.cgPath
        backgroundShapeLayer.fillColor = UIColor.clear.cgColor
        backgroundShapeLayer.strokeColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.00).cgColor
        backgroundShapeLayer.lineWidth = lineWidth
        containerView.layer.addSublayer(backgroundShapeLayer)

        // Foreground Cirle
        let foregroundCirclePath = UIBezierPath(arcCenter: containerView.center, radius: radius, startAngle: CGFloat((Double.pi * 3) / 2), endAngle: CGFloat((Double.pi * 3) / 2) + radiansFor(percentage: percentage), clockwise: true)
        let foregroundShapeLayer = CAShapeLayer()
        foregroundShapeLayer.path = foregroundCirclePath.cgPath
        foregroundShapeLayer.fillColor = UIColor.clear.cgColor
        foregroundShapeLayer.strokeColor = color.cgColor
        foregroundShapeLayer.lineWidth = lineWidth
        foregroundShapeLayer.lineCap = kCALineCapRound
        containerView.layer.addSublayer(foregroundShapeLayer)

        // Percentage Label
        let percentageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height))
        percentageLabel.center = containerView.center
        percentageLabel.text = "\(Int(percentage))%"
        percentageLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        percentageLabel.textAlignment = .center
        percentageLabel.textColor = Colors.lightGray
        containerView.addSubview(percentageLabel)
        
        // Constraints Foo
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: size).isActive = true
        heightAnchor.constraint(equalToConstant: size * 0.85).isActive = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: containerViewSize).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: containerViewSize).isActive = true
        
        // Text Label
        let textLabel = UILabel(frame: CGRect.zero)
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textLabel.textAlignment = .center
        textLabel.textColor = Colors.lightGray
        
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func radiansFor(percentage: Double) -> CGFloat {
        func degreeFor(percentage: Double) -> Double {
            return (percentage * 360.0) / 100.0
        }
        func radiansFor(degree: Double) -> CGFloat {
            let π = Double.pi
            return CGFloat((π * degree) / 180.0)
        }
        return radiansFor(degree: degreeFor(percentage: percentage))
    }
}
