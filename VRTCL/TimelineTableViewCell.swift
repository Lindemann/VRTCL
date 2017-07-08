//
//  TimelineTableViewCell.swift
//  VRTCL
//
//  Created by Lindemann on 07.07.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

internal struct TimelineTableViewCellViewModel {
	var photo = #imageLiteral(resourceName: "avatar")
	var kind = Kind.bouldering
	var name = "Judith Lindemann"
	
	internal var kindBadgeText: String {
		return kind == .bouldering ? "B" : "SC"
	}
	
	internal var kindBadgeColor: UIColor {
		return kind == .bouldering ? Colors.discoBlue : Colors.purple
	}
	
	internal var performanceButtonGrid: ButtonGrid {
		let climbsLabel = kind == .bouldering ? "Boulder" : "Routes"
		let climbsButton = CircleButtonWithText(mode: .outlineSmall, buttonText: "6", labelText: climbsLabel, color: Colors.lightGray)
		let bestEffortButton = CircleButtonWithText(mode: .outlineSmall, buttonText: "6", labelText: "Best Effort", color: Colors.lightGray)
		let durationButton = CircleButtonWithText(mode: .outlineSmall, buttonText: "6h", labelText: "Duration", color: Colors.lightGray)
		let items = [climbsButton, bestEffortButton, durationButton]
		return ButtonGrid(itemsPerRow: 3, items: items, spaceing: 20)
	}
	
	internal var climbsButtonGrid: ButtonGrid {
		let button1 = CircleButton(diameter: 30, text: "7+", color: Colors.magenta)
		let button2 = CircleButton(diameter: 30, text: "8+", color: Colors.babyBlue)
		let button3 = CircleButton(diameter: 30, text: "12", color: Colors.neonGreen)
		let items = [button1, button2, button3]
		let itemsPerRow = items.count < 6 ? items.count : 6
		return ButtonGrid(itemsPerRow: itemsPerRow, items: items, spaceing: 20)
	}
	
	var location = "Berlin, DAV Halle"
}

class TimelineTableViewCell: UITableViewCell {
	
	static let nibAndReuseIdentifier = String(describing: TimelineTableViewCell.self)
	
	var viewModel = TimelineTableViewCellViewModel() {
		didSet {
			setup()
		}
	}
	
	private let spacing: CGFloat = 20
	private let specialTopSpacing: CGFloat = 30
	
	private var photoButton: PhotoButton! {
		didSet {
			addSubview(photoButton)
			photoButton.translatesAutoresizingMaskIntoConstraints = false
			photoButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			photoButton.topAnchor.constraint(equalTo: topAnchor, constant: specialTopSpacing).isActive = true
			
			photoButton.isUserInteractionEnabled = false
		}
	}
	
	private var kindBadge: CircleButton! {
		didSet {
			let offset: CGFloat = 30
			addSubview(kindBadge)
			kindBadge.translatesAutoresizingMaskIntoConstraints = false
			kindBadge.centerXAnchor.constraint(equalTo: photoButton.centerXAnchor, constant: offset).isActive = true
			kindBadge.centerYAnchor.constraint(equalTo: photoButton.centerYAnchor, constant: -offset).isActive = true
			
			kindBadge.isUserInteractionEnabled = false
		}
	}
	
	private var nameLabel: UILabel! {
		didSet {
			nameLabel.textAlignment = .center
			nameLabel.font = Fonts.h3
			nameLabel.textColor = Colors.lightGray
			nameLabel.text = viewModel.name
			addSubview(nameLabel)
			nameLabel.translatesAutoresizingMaskIntoConstraints = false
			nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			nameLabel.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: spacing).isActive = true
		}
	}
	
	private var performanceButtonGrid: ButtonGrid! {
		didSet {
			// containerView is needed because the ButtonGrid needs translatesAutoresizingMaskIntoConstraints to be true
			let containerView = UIView()
			addSubview(containerView)
			containerView.addSubview(performanceButtonGrid)
			containerView.widthAnchor.constraint(equalToConstant: performanceButtonGrid.frame.size.width).isActive = true
			containerView.heightAnchor.constraint(equalToConstant: performanceButtonGrid.frame.size.height).isActive = true
			containerView.translatesAutoresizingMaskIntoConstraints = false
			containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			containerView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: spacing).isActive = true
			
			performanceButtonGrid.isUserInteractionEnabled = false
		}
	}
	
	private var climbsButtonGrid: ButtonGrid! {
		didSet {
			// containerView is needed because the ButtonGrid needs translatesAutoresizingMaskIntoConstraints to be true
			let containerView = UIView()
			addSubview(containerView)
			containerView.addSubview(climbsButtonGrid)
			containerView.widthAnchor.constraint(equalToConstant: climbsButtonGrid.frame.size.width).isActive = true
			containerView.heightAnchor.constraint(equalToConstant: climbsButtonGrid.frame.size.height).isActive = true
			containerView.translatesAutoresizingMaskIntoConstraints = false
			containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			containerView.topAnchor.constraint(equalTo: performanceButtonGrid.bottomAnchor, constant: spacing).isActive = true
			
			climbsButtonGrid.isUserInteractionEnabled = false
		}
	}
	
	private var locationLablel: UILabel! {
		didSet {
			locationLablel.textAlignment = .center
			locationLablel.font = Fonts.text
			locationLablel.textColor = Colors.lightGray
			locationLablel.text = "⚑ \(viewModel.location)"
			addSubview(locationLablel)
			locationLablel.translatesAutoresizingMaskIntoConstraints = false
			locationLablel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			locationLablel.topAnchor.constraint(equalTo: climbsButtonGrid.bottomAnchor, constant: spacing).isActive = true
		}
	}
	
	var height: CGFloat {
		return specialTopSpacing + photoButton.frame.height + spacing + nameLabel.frame.height + spacing + performanceButtonGrid.frame.height + spacing + climbsButtonGrid.frame.height + spacing + locationLablel.frame.height + spacing
	}
	
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super .init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		backgroundColor = selected ? Colors.darkGray.lighter(by: 10) : UIColor.clear
	}
	
	func setup() {
		selectionStyle = .none
		photoButton = PhotoButton(diameter: 80, image: viewModel.photo)
		kindBadge = CircleButton(diameter: 40, text: viewModel.kindBadgeText, color: viewModel.kindBadgeColor, presentingViewBackgroundColor: UIColor.white)
		nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
		performanceButtonGrid = viewModel.performanceButtonGrid
		climbsButtonGrid = viewModel.climbsButtonGrid
		locationLablel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
		
		heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
