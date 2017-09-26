//
//  FriendTableViewCell.swift
//  VRTCL
//
//  Created by Lindemann on 25.09.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class FriendTableViewCellViewModel {
	var user = User()
	var cell: FriendTableViewCell
	internal var photoURL: String? { return user.photoURL }
	internal var name: String? { return user.name }
	internal var followButtonMode: FollowButton.Mode  {
		return isFollowing ? .unfollow : .follow
	}
	internal var isFollowing = false
	
	init(user: User, cell: FriendTableViewCell) {
		self.user = user
		self.cell = cell
	}
	
	@objc func followOrUnfollowUser(sender: TagButton) {
		if !self.isFollowing {
			APIController.follow(friend: user, completion: { (success, error) in
				if success {
					self.isFollowing = true
					self.cell.setup()
				}
			})
		} else {
			APIController.unfollow(friend: user, completion: { (success, error) in
				if success {
					self.isFollowing = false
					self.cell.setup()
				}
			})
		}
	}
	
	func isFollowing(user: User)  {
		APIController.following { (success, error, users) in
			if success {
				guard let users = users else { return }
				for friend in users {
					if user.id == friend.id {
						self.isFollowing = true
						self.cell.setup()
						return
					}
				}
				self.isFollowing = false
				self.cell.setup()
			}
		}
	}
}

class FriendTableViewCell: UITableViewCell {
	
	var viewModel: FriendTableViewCellViewModel? {
		didSet {
			setup()
			if let viewModel = viewModel {
				viewModel.isFollowing(user: viewModel.user)
			}
		}
	}
	
    static let nibAndReuseIdentifier = String(describing: FriendTableViewCell.self)

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		backgroundColor = selected ? Colors.darkGray.lighter(by: 10) : UIColor.clear
    }
	
	var height: CGFloat { return 220 }
	
	func setup() {
		guard let viewModel = viewModel else { return }
		subviews.forEach { $0.removeFromSuperview() }
		selectionStyle = .none
		heightAnchor.constraint(equalToConstant: height).isActive = true
		seperator = UIView()

		let photoButton = PhotoButton(diameter: 80, mode: .photo)
		if let photoURL = viewModel.photoURL {
			let url = URL(string: photoURL)
			photoButton.kf.setImage(with: url, for: .normal)
		}
		
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
		label.textAlignment = .center
		label.font = Fonts.h3
		label.numberOfLines = 0;
		label.textColor = Colors.lightGray
		label.text = viewModel.name
		label.widthAnchor.constraint(equalToConstant: label.frame.size.width).isActive = true
		
		let followButton = FollowButton(mode: viewModel.followButtonMode)
		followButton.addTarget(viewModel, action: #selector(FriendTableViewCellViewModel.followOrUnfollowUser(sender:)), for: .touchUpInside)

		let stackView = UIStackView(arrangedSubviews: [photoButton, label, followButton])
		addSubview(stackView)
		stackView.spacing = 16
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		stackView.alignment = .center
		
		let arrow = UIImageView(image: #imageLiteral(resourceName: "fatButtonArrow"))
		arrow.tintColor = UIColor.white
		addSubview(arrow)
		arrow.translatesAutoresizingMaskIntoConstraints = false
		arrow.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		arrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
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
}

class FollowButton: TagButton {
	
	init(mode: Mode) {
		
		var color = Colors.lightGray
		switch mode {
		case .follow:
			color = Colors.lightGray
		case .unfollow:
			color = Colors.watermelon
		}
		super.init(text: mode.rawValue, color: color, interactionMode: .highlightable)
		defer { self.mode = mode }
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	enum Mode: String {
		case follow = "follow"
		case unfollow = "unfollow"
	}
	
	var mode: Mode = .unfollow
}














































































