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
}

class TimelineTableViewCell: UITableViewCell {
	
	static let nibAndReuseIdentifier = String(describing: TimelineTableViewCell.self)
	
	var viewModel = TimelineTableViewCellViewModel() {
		didSet {
			setup()
		}
	}
	
	private let spacing: CGFloat = 20
	private var photoButton: PhotoButton! {
		didSet {
			addSubview(photoButton)
			photoButton.translatesAutoresizingMaskIntoConstraints = false
			photoButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			photoButton.topAnchor.constraint(equalTo: topAnchor, constant: spacing).isActive = true
		}
	}
	
	private var kindBadge: CircleButton! {
		didSet {
			let offset: CGFloat = 30
			addSubview(kindBadge)
			kindBadge.translatesAutoresizingMaskIntoConstraints = false
			kindBadge.centerXAnchor.constraint(equalTo: photoButton.centerXAnchor, constant: offset).isActive = true
			kindBadge.centerYAnchor.constraint(equalTo: photoButton.centerYAnchor, constant: -offset).isActive = true
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
//			nameLabel.backgroundColor = UIColor.yellow
		}
	}
	
	private var performanceButtonGrid: ButtonGrid!
	private var climbsButtonGrid: ButtonGrid!
	private var locationLablel: UILabel!
	
	var height: CGFloat {
		return spacing + photoButton.frame.height + spacing + nameLabel.frame.height + spacing
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
		kindBadge.isUserInteractionEnabled = false
		nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
		
		
		
		
		heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
