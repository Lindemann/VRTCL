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
		case outlinedSmall
		case filledMedium
        case outlinedLarge
	}
	
	private let buttonSizeSmall: CGFloat = 40
	private let buttonSizeMedium: CGFloat = 60
    private let buttonSizeLarge: CGFloat = 80
	private let fontSizeSmall: CGFloat = 12
	private let fontSizeMedium: CGFloat = 16
    private let fontSizeLarge: CGFloat = 16
	private let sizeSmall: CGFloat = 62 // LOL 60 + 2 to make the string "Best Efford" fit
	private let sizeMedium: CGFloat = 90
	private let sizeLarge: CGFloat = 150
	
	var circleButton: CircleButton?
	var label: UILabel?
	
	let mode: Mode
	let buttonText: String
	let labelText: String
	let color: UIColor
	let image: UIImage?
	
	init(mode: Mode, center: CGPoint = CGPoint.zero, buttonText: String, labelText: String, color: UIColor = UIColor.gray, image: UIImage? = nil) {
		self.mode = mode
		self.buttonText = buttonText
		self.labelText = labelText
		self.color = color
		self.image = image
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
		case .outlinedSmall:
			frame.size = CGSize(width: sizeSmall, height: sizeSmall)
		case .filledMedium:
			frame.size = CGSize(width: sizeMedium, height: sizeMedium)
        case .outlinedLarge:
            frame.size = CGSize(width: sizeMedium, height: sizeLarge)
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
		case .outlinedSmall:
			label.font = UIFont.systemFont(ofSize: fontSizeSmall, weight: .medium)
		case .filledMedium:
			label.font = UIFont.systemFont(ofSize: fontSizeMedium, weight: .medium)
        case .outlinedLarge:
            label.font = UIFont.systemFont(ofSize: fontSizeLarge, weight: .medium)
		}
		
		// Button
		switch mode {
		case .outlinedSmall:
			circleButton = CircleButton(diameter: buttonSizeSmall, text: buttonText, color: Colors.lightGray, appearanceMode: .outlined, interactionMode: .highlightable, image: image)
		case .filledMedium:
			circleButton = CircleButton(diameter: buttonSizeMedium, text: buttonText, color: color, appearanceMode: .filled, interactionMode: .highlightable, image: image)
        case .outlinedLarge:
            circleButton = CircleButton(diameter: buttonSizeLarge, text: buttonText, color: color, appearanceMode: .outlined, interactionMode: .highlightable, image: image)
            circleButton?.titleLabel?.font = UIFont.systemFont(ofSize: 36, weight: .medium)
		}
		
		guard let circleButton = circleButton else { return }
		addSubview(circleButton)
		circleButton.translatesAutoresizingMaskIntoConstraints = false
		circleButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		circleButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        // Constraints Foo
        translatesAutoresizingMaskIntoConstraints = false
        
        switch mode {
        case .outlinedSmall:
            heightAnchor.constraint(equalToConstant: sizeSmall).isActive = true
            widthAnchor.constraint(equalToConstant: sizeSmall).isActive = true
        case .filledMedium:
            heightAnchor.constraint(equalToConstant: sizeMedium).isActive = true
            widthAnchor.constraint(equalToConstant: sizeMedium).isActive = true
        case .outlinedLarge:
            heightAnchor.constraint(equalToConstant: sizeLarge * 0.75).isActive = true
            widthAnchor.constraint(equalToConstant: sizeLarge).isActive = true
        }
	}
}

