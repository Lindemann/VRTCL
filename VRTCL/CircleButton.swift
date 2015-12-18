//
//  CircleButton.swift
//  Button
//
//  Created by Lindemann on 31/05/15.
//  Copyright (c) 2015 Lindemann. All rights reserved.
//

import UIKit

enum AppearanceMode {
    case Outlined
    case Filled
}

enum InteractionMode {
    case Activated
    case Deactivated
}

@IBDesignable
class CircleButton: UIButton {
    
    // MARK: Properties
    var text: String?
    var color: UIColor?
    var appearanceMode: AppearanceMode?
    var interactionMode: InteractionMode?
    let presentingViewBackgroundColor = UIColor.whiteColor()
    
    override var highlighted: Bool {
        didSet {
            if highlighted {
                if self.interactionMode == .Deactivated { return }
                    self.isFilled(self.setOutlinedApperance)
                    self.isOutlined(self.setFilledApperance)
            } else {
                if self.interactionMode == .Deactivated { return }
                    self.isFilled(self.setFilledApperance)
                    self.isOutlined(self.setOutlinedApperance)
            }
        }
    }
    
    // MARK: Initializer
    init(frame: CGRect, text: String, color: UIColor, appearanceMode: AppearanceMode, interactionMode: InteractionMode) {
        self.text = text
        self.color = color
        self.appearanceMode = appearanceMode
        self.interactionMode = interactionMode
        super.init(frame: frame)
        setUpButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForInterfaceBuilder() {
        setUpButton()
    }
    
    override func awakeFromNib() {
        setUpButton()
    }
    
    // MARK: SetUp
    func setUpButton() {
        setTitle(text, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(15)
        
        layer.cornerRadius = 0.5 * bounds.size.width
        layer.borderWidth = 1
        
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.textAlignment = NSTextAlignment.Center
        titleLabel?.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        let insets: CGFloat = 1
        titleEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        
        isFilled(setFilledApperance)
        isOutlined(setOutlinedApperance)
    }

    func isOutlined(function: () -> ()) {
        if self.appearanceMode == .Outlined {
            function()
        }
    }
    
    func isFilled(function: () -> ()) {
        if self.appearanceMode == .Filled {
            function()
        }
    }
    
    func setOutlinedApperance() {
        self.setTitleColor(self.color, forState: UIControlState.Normal)
        self.setTitleColor(self.color, forState: UIControlState.Highlighted)
        self.backgroundColor = UIColor.clearColor()
        self.layer.borderColor = self.color!.CGColor
    }
    
    func setFilledApperance() {
        self.setTitleColor(self.presentingViewBackgroundColor, forState: UIControlState.Normal)
        self.setTitleColor(self.presentingViewBackgroundColor, forState: UIControlState.Highlighted)
        self.backgroundColor = self.color
        self.layer.borderColor = UIColor.clearColor().CGColor
    }
}
