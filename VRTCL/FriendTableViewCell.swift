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
	
	var viewModel = FriendTableViewCellViewModel()

    static let nibAndReuseIdentifier = String(describing: FriendTableViewCell.self)

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
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
		heightAnchor.constraint(equalToConstant: height).isActive = true
	}

}
