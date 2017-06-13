//
//  CircleButton.swift
//  Button
//
//  Created by Lindemann on 31/05/15.
//  Copyright (c) 2015 Lindemann. All rights reserved.
//

import UIKit

enum AppearanceMode {
	case outlined
	case filled
}

internal class Button: UIButton {
	
	// MARK: Properties
	
	internal var text: String?
	internal var color: UIColor?
	internal var presentingViewBackgroundColor: UIColor?
	
	override var isSelected: Bool {
		didSet {
			if isSelected {
				appearanceMode = .filled
			} else {
				appearanceMode = .outlined
			}
		}
	}
	
	var appearanceMode: AppearanceMode? {
		didSet {
			let duration = 0.1
			if appearanceMode == .outlined {
				UIView.animate(withDuration: duration) { [weak self] in
					self?.setTitleColor(self?.color, for: UIControlState())
					self?.backgroundColor = UIColor.clear
					self?.layer.borderColor = self?.color?.cgColor ?? UIColor.green.cgColor
				}
			}
			if appearanceMode == .filled {
				UIView.animate(withDuration: duration) { [weak self] in
					self?.setTitleColor(self?.presentingViewBackgroundColor, for: UIControlState())
					self?.backgroundColor = self?.color
				}
			}
		}
	}
	
	// MARK: Initializer
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addTarget(self, action: #selector(wasTouched), for: .touchUpInside)
		
		widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
		heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@objc private func wasTouched() {
		isSelected = isSelected ? false : true
	}
	
}

@IBDesignable
class TagButton: Button {
	
	init(text: String, presentingViewBackgroundColor: UIColor?) {
		let nsString = text as NSString
		let font = UIFont.systemFont(ofSize: 16)
		let insets: CGFloat = 14
		
		let stringSize = nsString.size(withAttributes: [NSAttributedStringKey.font: font])
		let frame = CGRect(x: 200, y: 300, width: stringSize.width + insets * 2, height: 30)
		
		super.init(frame: frame)
		self.color = Colors.lightGray
		self.presentingViewBackgroundColor = presentingViewBackgroundColor
		
		setTitle(text, for: .normal)
		titleLabel?.font = font
		
		layer.cornerRadius = 14
		layer.borderWidth = 1
		layer.borderColor = color?.cgColor
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}


@IBDesignable
class CircleButton: Button {
	
	// MARK: Initializer
	
	init(center: CGPoint, diameter: CGFloat, text: String, color: UIColor, presentingViewBackgroundColor: UIColor?, isSelected: Bool = false, isEnabled: Bool = true) {
		super.init(frame: CGRect(x: center.x - diameter/2, y: center.y - diameter/2, width: diameter, height: diameter))
		self.frame = CGRect(x: center.x - diameter/2, y: center.y - diameter/2, width: diameter, height: diameter)
		self.text = text
		self.color = color
		self.isEnabled = isEnabled
		self.presentingViewBackgroundColor = presentingViewBackgroundColor
		// trigger didSet of propertys http://stackoverflow.com/a/33979852/647644
		defer {
			self.isSelected = isSelected
		}
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override func prepareForInterfaceBuilder() {
		setup()
	}
	
	override func awakeFromNib() {
		setup()
	}
	
	// MARK: SetUp
	
	func setup() {
		setTitle(text, for: UIControlState())
		titleLabel?.font = UIFont.systemFont(ofSize: 15)
		
		layer.cornerRadius = 0.5 * bounds.size.width
		layer.borderWidth = 1
		layer.borderColor = self.color?.cgColor ?? UIColor.green.cgColor
		
		titleLabel?.adjustsFontSizeToFitWidth = true
		titleLabel?.textAlignment = .center
		titleLabel?.baselineAdjustment = .alignCenters
		let insets: CGFloat = 1
		titleEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
	}
	
}

@IBDesignable
class FatButton: UIButton {
	
	@IBInspectable
	var color: UIColor? = UIColor.gray {
		didSet {
			setup()
		}
	}
	
	var hasArrow: Bool = false {
		didSet {
			setup()
		}
	}
	
	override var isHighlighted: Bool {
		didSet {
			if isHighlighted {
				backgroundColor = color?.darker(by: 20)
			} else {
				backgroundColor = color
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	init(origin: CGPoint, color: UIColor?, title: String, hasArrow: Bool = false) {
		super.init(frame: CGRect.zero)
		self.frame = CGRect(origin: origin, size: self.intrinsicContentSize)
		self.color = color
		self.setTitle(title, for: .normal)
		self.hasArrow = hasArrow
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		layer.cornerRadius = frame.size.height / CGFloat(2)
		clipsToBounds = true
		backgroundColor = color
		titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
		setTitleColor(UIColor.white, for: .normal)
		setTitleColor(UIColor.white, for: .highlighted)
		setTitleColor(UIColor.white, for: .selected)
		
		if hasArrow {
			let imageView = UIImageView(image: #imageLiteral(resourceName: "fatButtonArrow"))
			imageView.tintColor = UIColor.white
			imageView.center = center
			imageView.frame.origin.x = frame.width - 40
			addSubview(imageView)
		}
	}
	
	override var intrinsicContentSize: CGSize {
		return CGSize(width: 300, height: 60)
	}
	
	override func prepareForInterfaceBuilder() {
		setup()
	}
}
