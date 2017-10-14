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
		return user.isFriend ? .unfollow : .follow
	}
	
	init(user: User, cell: FriendTableViewCell) {
		self.user = user
		self.cell = cell
	}
	
	@objc func followOrUnfollowUser(sender: TagButton) {
		if !self.user.isFriend {
			APIController.follow(friend: user, completion: { (success, error) in
				if success {
					self.user.isFriend = true
					self.cell.setup()
				}
			})
		} else {
			APIController.unfollow(friend: user, completion: { (success, error) in
				if success {
					self.user.isFriend = false
					self.cell.setup()
				}
			})
		}
	}
}

class FriendTableViewCell: UITableViewCell {
	
	var viewModel: FriendTableViewCellViewModel? { didSet { setup() } }
	
    static let nibAndReuseIdentifier = String(describing: FriendTableViewCell.self)

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		backgroundColor = selected ? Colors.darkGray.lighter(by: 10) : UIColor.clear
    }
	
	func setup() {
		guard let viewModel = viewModel else { return }
		subviews.forEach { $0.removeFromSuperview() }
		selectionStyle = .none
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
		
		heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: 60).isActive = true
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













































































