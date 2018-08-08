//
//  FatTextField.swift
//  VRTCL
//
//  Created by Lindemann on 27.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class FatTextField: UITextField {
	
	private var inset: CGFloat = 20
	
	override var placeholder: String? {
		didSet {
			if let placeholder = placeholder {
				attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: Colors.lightGray.darker(by: 20)])
			}
		}
	}
	
	convenience init(origin: CGPoint = CGPoint.zero) {
		let frame = CGRect(origin: origin, size: CGSize(width: 300, height: 40))
		self.init(frame: frame)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		borderStyle = .none
		layer.cornerRadius = frame.size.height / CGFloat(2)
		layer.borderColor = Colors.lightGray.cgColor
		layer.borderWidth = 2
		clipsToBounds = true
		textColor = Colors.lightGray
		backgroundColor = Colors.lightGray.withAlphaComponent(0.14)
		keyboardAppearance = .dark
		clearButtonMode = .whileEditing
		
		widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
		heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: inset, dy: 0)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: inset, dy: 0)
	}
	
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: inset, dy: 0)
	}
	
	override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.clearButtonRect(forBounds: bounds)
		rect.origin.x -= 5
		return rect
	}
}
