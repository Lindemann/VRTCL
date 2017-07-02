//
//  DurationView.swift
//  VRTCL
//
//  Created by Lindemann on 01.07.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

protocol DurationViewDelegate: class {
	func userHasChanged(duration: Int)
}

class DurationView: UIView {
	
	var duration: Int = 0 {
		didSet {
			if duration > 24 {
				duration = 24
			} else if duration < 0 {
				duration = 0
			}
			label.text = "\(duration)h"
		}
	}
	private var label: UILabel!
	private var plusButton: CircleButton!
	private var minusButton: CircleButton!
	weak var delegate: DurationViewDelegate?

	init() {
		let frame = CGRect(x: 0, y: 0, width: 200, height: 80)
		super.init(frame: frame)
		setupLabel()
		setupButtons()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupLabel() {
		let frame = CGRect(x: 0, y: 0, width: 80, height: 80)
		label = UILabel(frame: frame)
		
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 65, weight: .light)
		label.textColor = Colors.lightGray
		label.text = "\(duration)h"
		
		addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}
	
	private func setupButtons() {
		minusButton = CircleButton(diameter: 30, text: "-", color: Colors.lightGray, appearanceMode: .outlined, interactionMode: .highlightable)
		minusButton.addTarget(self, action: #selector(minus), for: .touchUpInside)
		addSubview(minusButton)
		minusButton.translatesAutoresizingMaskIntoConstraints = false
		minusButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		minusButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		
		plusButton = CircleButton(diameter: 30, text: "+", color: Colors.lightGray, appearanceMode: .outlined, interactionMode: .highlightable)
		plusButton.addTarget(self, action: #selector(plus), for: .touchUpInside)
		addSubview(plusButton)
		plusButton.translatesAutoresizingMaskIntoConstraints = false
		plusButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		plusButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		
		let font = UIFont.systemFont(ofSize: 32, weight: .regular)
		let titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
		minusButton.titleLabel?.font = font
		plusButton.titleLabel?.font = font
		minusButton.titleEdgeInsets = titleEdgeInsets
		plusButton.titleEdgeInsets = titleEdgeInsets
	}
	
	@objc private func plus() {
		duration += 1
		delegate?.userHasChanged(duration: duration)
	}
	
	@objc private func minus() {
		duration -= 1
		delegate?.userHasChanged(duration: duration)
	}
}
