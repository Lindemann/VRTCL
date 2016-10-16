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

@IBDesignable
class TagButton: UIButton {
    
    init(text: String) {
        
        let nsString = text as NSString
        let font = UIFont.systemFont(ofSize: 16)
        let insets: CGFloat = 12
        
        let stringSize = nsString.size(attributes: [NSFontAttributeName: font])
        let frame = CGRect(x: 200, y: 300, width: stringSize.width + insets * 2, height: 30)
        super.init(frame: frame)
        
        setTitle("redpoint", for: .normal)
        titleLabel?.font = font
        
        layer.cornerRadius = 14
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insets, bottom: 0, right: insets)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


@IBDesignable
class CircleButton: UIButton {
    
    // MARK: Properties
    
    private var text: String?
    private var color: UIColor?
    
    // Workaround for this http://stackoverflow.com/questions/25828987/swift-property-getter-ivar
    private var _presentingViewBackgroundColor: UIColor?
    private var presentingViewBackgroundColor: UIColor? {
        set(newValue) {
            _presentingViewBackgroundColor = newValue
        }
        get {
            if let presentingViewBackgroundColor = _presentingViewBackgroundColor {
                return presentingViewBackgroundColor
            } else {
                if let backgroundColor = self.superview?.backgroundColor {
                    return backgroundColor
                } else {
                    return UIColor.red
                }
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isSelected {return}
            if isHighlighted {
                appearanceMode = .filled
            } else {
                appearanceMode = .outlined
            }
        }
    }
    
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
                    self?.setTitleColor(self?.color, for: UIControlState.highlighted)
                    self?.backgroundColor = UIColor.clear
                    self?.layer.borderColor = self?.color!.cgColor
                }
            }
            if appearanceMode == .filled {
                UIView.animate(withDuration: duration) { [weak self] in
                    self?.setTitleColor(self?.presentingViewBackgroundColor, for: UIControlState())
                    self?.setTitleColor(self?.presentingViewBackgroundColor, for: UIControlState.highlighted)
                    self?.backgroundColor = self?.color
                }
            }
        }
    }
    
    // MARK: Initializer
    
    init(center: CGPoint, diameter: CGFloat, text: String, color: UIColor, presentingViewBackgroundColor: UIColor? = nil, isSelected: Bool = false, isEnabled: Bool = true) {
        super.init(frame: CGRect(x: center.x - diameter/2, y: center.y - diameter/2, width: diameter, height: diameter))
        self.text = text
        self.color = color
        self.isEnabled = isEnabled
        self.presentingViewBackgroundColor = presentingViewBackgroundColor
        // trigger didSet of propertys http://stackoverflow.com/a/33979852/647644
        defer {
            self.isSelected = isSelected
        }
        setUpButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpButton()
    }
    
    override func prepareForInterfaceBuilder() {
        setUpButton()
    }
    
    override func awakeFromNib() {
        setUpButton()
    }
    
    // MARK: SetUp
    
    func setUpButton() {
        setTitle(text, for: UIControlState())
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        layer.cornerRadius = 0.5 * bounds.size.width
        layer.borderWidth = 1
        
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.baselineAdjustment = UIBaselineAdjustment.alignCenters
        let insets: CGFloat = 1
        titleEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        
        addTarget(self, action: #selector(wasTouched), for: .touchUpInside)
    }
    
    @objc private func wasTouched() {
        isSelected = isSelected ? false : true
    }
}
