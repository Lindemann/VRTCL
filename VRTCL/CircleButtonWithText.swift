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
	
	private let buttonSizeSmall: CGFloat = 40
	private let buttonSizeMedium: CGFloat = 60
	private let fontSizeSmall: CGFloat = 12
	private let fontSizeMedium: CGFloat = 16
	private let sizeSmall: CGFloat = 62 // LOL 60 + 2 to make "Best Efford" fit
	private let sizeMedium: CGFloat = 90
	
	
	var circleButton: CircleButton?
	var label: UILabel?
	
	let mode: Mode
	let buttonText: String
	let labelText: String
	let color: UIColor
	
	init(mode: Mode, center: CGPoint = CGPoint.zero, buttonText: String, labelText: String, color: UIColor = UIColor.gray) {
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
		
		// Frame
		switch mode {
		case .outlineSmall:
			frame.size = CGSize(width: sizeSmall, height: sizeSmall)
		case .filledMedium:
			frame.size = CGSize(width: sizeMedium, height: sizeMedium)
		}
		
		// Label
		label = UILabel(frame: CGRect.zero)
		guard let label = label else { return }
		label.text = labelText
		label.textColor = Colors.lightGray
		label.textAlignment = .center
		label.lineBreakMode = .byWordWrapping
		
		addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		
		switch mode {
		case .outlineSmall:
			label.font = UIFont.systemFont(ofSize: fontSizeSmall, weight: .medium)
		case .filledMedium:
			label.font = UIFont.systemFont(ofSize: fontSizeMedium, weight: .medium)
		}
		
		// Button
		switch mode {
		case .outlineSmall:
			circleButton = CircleButton(center: CGPoint.zero, diameter: buttonSizeSmall, text: buttonText, color: Colors.lightGray, appearanceMode: .outlined, interactionMode: .highlightable)
		case .filledMedium:
			circleButton = CircleButton(center: CGPoint.zero, diameter: buttonSizeMedium, text: buttonText, color: color, appearanceMode: .filled, interactionMode: .highlightable)
		}
		
		guard let circleButton = circleButton else { return }
		addSubview(circleButton)
		circleButton.translatesAutoresizingMaskIntoConstraints = false
		circleButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		circleButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
	}
}

