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
	var hasTopSpacing = true { didSet { updateViews() } }
	var hasBottomSpacing = true { didSet { updateViews() } }
	
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
			label.topAnchor.constraint(equalTo: topAnchor, constant: (hasTopSpacing ? spacing : 0)).isActive = true
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
			view.topAnchor.constraint(equalTo: topAnchor, constant: (hasTopSpacing ? spacing : 0) + labelHeight + spacing).isActive = true
		}
	}
	
	var height: CGFloat {
		return (hasTopSpacing ? spacing : 0) + labelHeight + (content?.frame.size.height != nil ? ((content?.frame.size.height ?? 0) + spacing) : 0) + (hasBottomSpacing ? spacing : 0)
	}
	
	init() {
		super.init(style: .default, reuseIdentifier: SessionsTableViewCell.nibAndReuseIdentifier)
		backgroundColor = UIColor.clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func updateViews() {
		subviews.forEach { $0.removeFromSuperview() }
		heading = { heading }()
		content = { content }()
	}
}

class SessionsTableViewHeaderFooterView: UITableViewHeaderFooterView {
	
	static let nibAndReuseIdentifier = String(describing: SessionsTableViewHeaderFooterView.self)
	
	let spacing: CGFloat = 50
	
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
			view.topAnchor.constraint(equalTo: topAnchor, constant: spacing).isActive = true
			view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: spacing).isActive = true
		}
	}
	
	var height: CGFloat {
		return spacing + (content?.frame.size.height ?? 0) + spacing
	}
	
	init() {
		super.init(reuseIdentifier: SessionsTableViewHeaderFooterView.nibAndReuseIdentifier)
//		backgroundView = UIView()
//		backgroundView!.backgroundColor = UIColor.clear
		contentView.backgroundColor = Colors.darkGray
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

