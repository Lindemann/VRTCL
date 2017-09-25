//
//  TimelineTableViewCell.swift
//  VRTCL
//
//  Created by Lindemann on 07.07.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

struct TimelineTableViewCellViewModel {
	var user = User()
	var session: Session?
	
	internal var kind: Kind? { return session?.kind }
	internal var photoURL: String? { return user.photoURL }
	internal var name: String? { return user.name }
	internal var location: String { return session?.location?.name ?? "" }
	internal var numberOfClimbs: Int { return session?.climbs?.count ?? 0 }
	internal var bestEffort: String {
		if let session = session, let climb = Statistics.bestEffort(session: session) {
			return "\(climb.grade?.value ?? "0")"
		}
		return "0"
	}
	internal var duration: Int { return session?.duration ?? 0 }
	internal var climbs: [Climb] { return session?.climbs ?? [] }
	internal var mood: Mood? { return session?.mood }
	
	internal var kindBadgeText: String {
		return kind == .bouldering ? "B" : "SC"
	}
	
	internal var kindBadgeColor: UIColor {
		return kind == .bouldering ? Colors.discoBlue : Colors.purple
	}
	
	internal var performanceButtonGrid: ButtonGrid {
		let climbsLabel = kind == .bouldering ? "Boulder" : "Routes"
		let climbsButton = CircleButtonWithText(mode: .outlinedSmall, buttonText: "\(numberOfClimbs)", labelText: climbsLabel, color: Colors.lightGray)
		let bestEffortButton = CircleButtonWithText(mode: .outlinedSmall, buttonText: bestEffort, labelText: "Best Effort", color: Colors.lightGray)
		let durationButton = CircleButtonWithText(mode: .outlinedSmall, buttonText: "\(duration)", labelText: "Duration", color: Colors.lightGray)
		var items = [climbsButton, bestEffortButton, durationButton]
		var itemsPerRow = 3
		if let mood = mood {
			itemsPerRow = 4
			let moodButton = CircleButtonWithText(mode: .outlinedSmall, buttonText: "\(duration)", labelText: "Mood", color: Colors.lightGray, image: UIImage(named: mood.rawValue))
			items.append(moodButton)
		}
		return ButtonGrid(itemsPerRow: itemsPerRow, items: items, spaceing: 20)
	}
	
	internal var climbsButtonGrid: ButtonGrid? {
		var items: [CircleButton] = []
		for climb in climbs {
			let button = CircleButton(diameter: 30, text: climb.grade?.value ?? "0", color: UIColor(hex: climb.grade?.color))
			if climb.style == .toprope || climb.style == .attempt {
				button.alpha = 0.4
			}
			items.append(button)
		}
		let itemsPerRow = items.count < 6 ? items.count : 6
		return ButtonGrid(itemsPerRow: itemsPerRow, items: items, spaceing: 20)
	}
}

class TimelineTableViewCell: UITableViewCell {
	
	static let nibAndReuseIdentifier = String(describing: TimelineTableViewCell.self)
	
	var viewModel = TimelineTableViewCellViewModel() {
		didSet { setup() }
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
			nameLabel.numberOfLines = 0
			addSubview(nameLabel)
			nameLabel.translatesAutoresizingMaskIntoConstraints = false
			nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			nameLabel.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: spacing).isActive = true
			nameLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
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
	
	private var seperator: UIView! {
		didSet {
			seperator.backgroundColor = Colors.lightGray
			addSubview(seperator)
			seperator.translatesAutoresizingMaskIntoConstraints = false
			seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
			seperator.widthAnchor.constraint(equalTo: widthAnchor, constant: -60).isActive = true
			seperator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			seperator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		}
	}
	
	var height: CGFloat {
		return specialTopSpacing + photoButton.frame.height + spacing + nameLabel.frame.height + spacing + performanceButtonGrid.frame.height + spacing + climbsButtonGrid.frame.height + spacing + locationLablel.frame.height + spacing
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		backgroundColor = selected ? Colors.darkGray.lighter(by: 10) : UIColor.clear
	}
	
	func setup() {
		subviews.forEach { $0.removeFromSuperview() }
		selectionStyle = .none
		
		photoButton = PhotoButton(diameter: 80, mode: .photo)
		if let photoURL = viewModel.user.photoURL {
			photoButton.kf.setImage(with: URL(string: photoURL), for: .normal)
		}
		
		kindBadge = CircleButton(diameter: 40, text: viewModel.kindBadgeText, color: viewModel.kindBadgeColor, presentingViewBackgroundColor: UIColor.white)
		nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
		performanceButtonGrid = viewModel.performanceButtonGrid
		climbsButtonGrid = viewModel.climbsButtonGrid
		locationLablel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
		seperator = UIView()
		heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
