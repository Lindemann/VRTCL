//
//  SessionsTableViewCell.swift
//  VRTCL
//
//  Created by Lindemann on 17.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class SessionsTableViewCell: UITableViewCell {
	
	static let nibAndReuseIdentifier = String(describing: SessionsTableViewCell.self)
	
	let spacing: CGFloat = 50
	private let labelHeight: CGFloat = 40
	
	var heading: String? {
		didSet {
			guard let heading = heading else { return }
			let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: labelHeight))
			label.textAlignment = .center
			label.font = Fonts.h1
			label.textColor = UIColor.white
			label.text = heading
			addSubview(label)
			
			label.translatesAutoresizingMaskIntoConstraints = false
			label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			label.topAnchor.constraint(equalTo: topAnchor, constant: spacing).isActive = true
		}
	}
	
	var content: UIView? {
		didSet {
			guard let content = content else { return }
			let view = UIView()
			addSubview(view)
			view.addSubview(content)
			
			view.translatesAutoresizingMaskIntoConstraints = false
			view.widthAnchor.constraint(equalToConstant: content.frame.size.width).isActive = true
			view.heightAnchor.constraint(equalToConstant: content.frame.size.height).isActive = true
			view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			view.topAnchor.constraint(equalTo: topAnchor, constant: spacing + labelHeight + spacing).isActive = true
		}
	}
	
	var height: CGFloat {
		return spacing + labelHeight + spacing + (content?.frame.size.height ?? 0)
	}
	
	init() {
		super.init(style: .default, reuseIdentifier: " ")
		backgroundColor = UIColor.clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

