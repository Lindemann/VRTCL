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
    // Workaround for this http://stackoverflow.com/questions/25828987/swift-property-getter-ivar
    internal var _presentingViewBackgroundColor: UIColor?
    internal var presentingViewBackgroundColor: UIColor? {
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
                    print("🚧 Button has no super view yet. Set the presentingViewBackgroundColor 🎨 in the initializer.")
                    return UIColor.red
                }
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
    
    init(text: String) {
        
        let nsString = text as NSString
        let font = UIFont.systemFont(ofSize: 16)
        let insets: CGFloat = 14
        
        let stringSize = nsString.size(attributes: [NSFontAttributeName: font])
        let frame = CGRect(x: 200, y: 300, width: stringSize.width + insets * 2, height: 30)
        
        super.init(frame: frame)
        color = UIColor.white

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
    
    init(center: CGPoint, diameter: CGFloat, text: String, color: UIColor, presentingViewBackgroundColor: UIColor? = nil, isSelected: Bool = false, isEnabled: Bool = true) {
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
    
    init(origin: CGPoint, color: UIColor, title: String) {
        super.init(frame: CGRect.zero)
        self.frame = CGRect(origin: origin, size: self.intrinsicContentSize)
        self.color = color
        self.setTitle(title, for: .normal)
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
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        setTitleColor(UIColor.white, for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 60)
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
}
