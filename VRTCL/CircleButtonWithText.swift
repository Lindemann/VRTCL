//
//  CircleButtonWithText.swift
//  VRTCL
//
//  Created by Lindemann on 13.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class CircleButtonWithText: UIView {
	
	enum Mode {
		case outlineSmall
		case filledMedium
	}
	
	var circleButton: CircleButton?
	var label: UILabel?
	
	let mode: Mode
	let buttonText: String
	let labelText: String
	let color: UIColor
	
	init(mode: Mode, center: CGPoint, buttonText: String, labelText: String, color: UIColor = UIColor.gray) {
		self.mode = mode
		self.buttonText = buttonText
		self.labelText = labelText
		self.color = color
		super.init(frame: CGRect.zero)
		self.center = center
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		backgroundColor = UIColor.yellow
		// Button
		switch mode {
		case .outlineSmall:
			let size = 60
			frame.size = CGSize(width: size, height: size)
			circleButton = CircleButton(center: CGPoint.zero, diameter: 40, text: buttonText, color: Colors.lightGray, presentingViewBackgroundColor: backgroundColor, isSelected: false, isEnabled: true)
		case .filledMedium:
			let size = 80
			frame.size = CGSize(width: size, height: size)
			circleButton = CircleButton(center: CGPoint.zero, diameter: 60, text: buttonText, color: color, presentingViewBackgroundColor: backgroundColor, isSelected: true, isEnabled: true)
		}
		guard let circleButton = circleButton else { return }
		addSubview(circleButton)
		circleButton.translatesAutoresizingMaskIntoConstraints = false
		circleButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		circleButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
		
		// Label
	}
}

