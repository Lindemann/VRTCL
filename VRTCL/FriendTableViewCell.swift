//
//  FriendTableViewCell.swift
//  VRTCL
//
//  Created by Lindemann on 25.09.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

struct FriendTableViewCellViewModel {
	var user = User()
	internal var photoURL: String? { return user.photoURL }
	internal var name: String? { return user.name }
}

class FriendTableViewCell: UITableViewCell {
	
	var viewModel = FriendTableViewCellViewModel() {
		didSet { setup() }
	}

    static let nibAndReuseIdentifier = String(describing: FriendTableViewCell.self)

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		backgroundColor = selected ? Colors.darkGray.lighter(by: 10) : UIColor.clear
    }
	
	var height: CGFloat {
		return 220
	}
	
	private func setup() {
		subviews.forEach { $0.removeFromSuperview() }
		selectionStyle = .none

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
		
		let followButton = TagButton(text: "follow", interactionMode: .highlightable)
		followButton.addTarget(self, action: #selector(followUser(sender:)), for: .touchUpInside)

		let stackView = UIStackView(arrangedSubviews: [photoButton, label, followButton])
		addSubview(stackView)
		stackView.spacing = 16
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		stackView.alignment = .center
		
		seperator = UIView()
		
		heightAnchor.constraint(equalToConstant: height).isActive = true
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

extension FriendTableViewCell {
	// This has no business in the cell class...but YOLO
	@objc func followUser(sender: TagButton) {
		TagButton(text: "unfollow", interactionMode: .highlightable)
	}
}
