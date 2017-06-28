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
		layer.borderColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.00).cgColor
		layer.borderWidth = 2
		clipsToBounds = true
		
//		clearButtonMode = .always
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
}
