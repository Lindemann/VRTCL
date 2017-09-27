//
//  CircleButton.swift
//  Button
//
//  Created by Lindemann on 31/05/15.
//  Copyright (c) 2015 Lindemann. All rights reserved.
//

import UIKit

internal class Button: UIButton {
	
	enum AppearanceMode {
		case outlined
		case filled
	}
	
	enum InteractionMode {
		case highlightable
		case selectable
	}
	
	internal var text: String?
	internal var color: UIColor?
	internal var presentingViewBackgroundColor: UIColor?
	
	override var isSelected: Bool {
		didSet {
			guard interactionMode == .selectable else { return }
			if isSelected {
				appearanceMode = .filled
			} else {
				appearanceMode = .outlined
			}
		}
	}
	
	override var isHighlighted: Bool {
		didSet {
			guard interactionMode == .highlightable else { return }
			if isHighlighted {
				appearanceMode = initialAppearanceMode == .filled ? .outlined : .filled
			} else {
				appearanceMode = initialAppearanceMode
			}
		}
	}
	
	// Super anoying property, but it is needed to fix a bug with isHighlighted
	// isHighlighted is called all the time at long presses and the colors are flickering with ternary "outlined/filled" switches
	// initialAppearanceMode is used to reset the original setting after highlighting
	internal var initialAppearanceMode: AppearanceMode?
	
	var appearanceMode: AppearanceMode? {
		didSet {
			let duration = 0.1
			if appearanceMode == .outlined {
				UIView.animate(withDuration: duration) { [weak self] in
					self?.setTitleColor(self?.color, for: UIControlState())
					self?.backgroundColor = UIColor.clear
					self?.layer.borderColor = self?.color?.cgColor ?? UIColor.green.cgColor
					self?.imageView?.tintColor = self?.color
				}
			}
			if appearanceMode == .filled {
				UIView.animate(withDuration: duration) { [weak self] in
					self?.setTitleColor(self?.presentingViewBackgroundColor, for: UIControlState())
					self?.backgroundColor = self?.color
					self?.imageView?.tintColor = self?.presentingViewBackgroundColor
				}
			}
		}
	}
	
	var interactionMode: InteractionMode? {
		didSet {
			if interactionMode == .selectable && appearanceMode == .filled {
				isSelected = true
			}
		}
	}
	
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

class TagButton: Button {
	
	init(text: String, color: UIColor = Colors.lightGray, presentingViewBackgroundColor: UIColor? = Colors.darkGray, appearanceMode: AppearanceMode = .outlined, interactionMode: InteractionMode = .selectable, origin: CGPoint = CGPoint.zero) {
		let nsString = text as NSString
		let font = UIFont.systemFont(ofSize: 16, weight: .medium)
		let insets: CGFloat = 14
		
		let stringSize = nsString.size(withAttributes: [NSAttributedStringKey.font: font])
		let frame = CGRect(x: origin.x, y: origin.y, width: stringSize.width + insets * 2, height: 30)
		
		super.init(frame: frame)
		self.color = color
		self.presentingViewBackgroundColor = presentingViewBackgroundColor
		self.initialAppearanceMode = appearanceMode
		defer {
			self.appearanceMode = appearanceMode
			self.interactionMode = interactionMode
		}
		
		setTitle(text, for: .normal)
		titleLabel?.font = font
		
		layer.cornerRadius = 14
		layer.borderWidth = 2
		layer.borderColor = color.cgColor
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}

class CircleButton: Button {
	
	var image: UIImage?
	
	// MARK: Initializer
	
		init(center: CGPoint = CGPoint.zero, diameter: CGFloat = 60, text: String = "", color: UIColor = UIColor.yellow, presentingViewBackgroundColor: UIColor = Colors.darkGray, appearanceMode: AppearanceMode = .filled, interactionMode: InteractionMode = .selectable, image: UIImage? = nil) {
		super.init(frame: CGRect(x: center.x - diameter/2, y: center.y - diameter/2, width: diameter, height: diameter))
		self.frame = CGRect(x: center.x - diameter/2, y: center.y - diameter/2, width: diameter, height: diameter)
		self.text = text
		self.color = color
		self.tintColor = color
		self.presentingViewBackgroundColor = presentingViewBackgroundColor
		self.image = image
		self.initialAppearanceMode = appearanceMode
		// trigger didSet of propertys http://stackoverflow.com/a/33979852/647644
		defer {
			self.appearanceMode = appearanceMode
			self.interactionMode = interactionMode
		}
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func setup() {
		layer.cornerRadius = 0.5 * bounds.size.width
		layer.borderWidth = 2
		layer.borderColor = self.color?.cgColor ?? UIColor.green.cgColor
		
		setTitle(text, for: UIControlState())
		titleLabel?.font = UIFont.systemFont(ofSize: 80, weight: .medium)
		titleLabel?.adjustsFontSizeToFitWidth = true
		titleLabel?.textAlignment = .center
		titleLabel?.baselineAdjustment = .alignCenters

		// Adjusting the inset percentage basesd on character count
		// since uikit only calculates the label width to fit the button we ignore the height
		var inset: CGFloat = 0
		if let count = titleLabel?.text?.characters.count {
			switch count {
			case 1:
				inset = frame.size.width * 0.35
				if titleLabel?.text == "1" { inset = frame.size.width * 0.38 } // 1 looks way to big
			case 2:
				inset = frame.size.width * 0.25
			case 3:
				inset = frame.size.width * 0.15
			case 4:
				inset = frame.size.width * 0.05
			case 5:
				inset = frame.size.width * 0.05 // text like 5.15c behaves strange
			default:
				inset = 0
			}
		}
		// top and buttom has no influence
		titleEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
		
		if let image = image {
			imageView?.contentMode = .scaleAspectFit
			// TODO: Fix me with small images
			let inset: CGFloat = 8 // Ugly AF...shriks the image for the small face button
			imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
			setImage(image.withRenderingMode(.alwaysTemplate), for: UIControlState())
			adjustsImageWhenHighlighted = false
		}
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
	
	init(origin: CGPoint = CGPoint.zero, color: UIColor = UIColor.yellow, title: String, hasArrow: Bool = false) {
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
		
		widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
		heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
		
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

class PhotoButton: UIButton {
	
	enum Mode {
		case button
		case photo
	}
	
	override var isHighlighted: Bool {
		didSet {
			if isHighlighted {
				backgroundColor = Colors.lightGray.darker(by: 20)
			} else {
				backgroundColor = Colors.lightGray
			}
		}
	}
	
	var mode: Mode {
		didSet {
			switch mode {
			case .button:
				setTitle("Add Photo", for: .normal)
			case .photo:
				setTitle("⊙▂⊙", for: .normal)
//				setTitleColor(Colors.lightGray, for: .normal)
//				let colors = [Colors.babyBlue, Colors.hardPurple, Colors.neonGreen, Colors.magenta, Colors.mint, Colors.orange, Colors.mauve, Colors.pink, Colors.watermelon]
//				backgroundColor = colors[Int(arc4random_uniform(UInt32(colors.count)))]
			}
		}
	}
	
	init(center: CGPoint = CGPoint.zero, diameter: CGFloat = 80, image: UIImage? = nil, mode: Mode = .button) {
		self.mode = mode
		super.init(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
		self.center = center
		widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
		heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
		
		layer.cornerRadius = frame.size.height / CGFloat(2)
		clipsToBounds = true
		
		if let image = image {
			imageView?.contentMode = .scaleAspectFill
            setImage(image, for: UIControlState())
		}
		
		defer { self.mode = mode }
		titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
		setTitleColor(UIColor.white, for: .normal)
		backgroundColor = Colors.lightGray
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
