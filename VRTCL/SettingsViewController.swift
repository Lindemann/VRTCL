//
//  SettingsViewController.swift
//  VRTCL
//
//  Created by Lindemann on 19.09.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import Foundation

import UIKit

internal struct SettingsViewControllerViewModel {

}

class SettingsViewController: UIViewController {
	
	let user = AppDelegate.shared.user
	var viewModel = SettingsViewControllerViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = Colors.darkGray
		navigationItem.title = "Settings"
		setup()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setup()
	}
	
	private func setup() {
		view.subviews.forEach({ $0.removeFromSuperview() })
		
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
		label.textAlignment = .center
		label.font = Fonts.h3
		label.numberOfLines = 0;
		label.textColor = Colors.lightGray
		label.text = "\(user.name ?? "")\n\(user.email ?? "")"
		
		let logoutButton = FatButton(color: Colors.purple, title: "Logout")
		logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
		
		let stackView = UIStackView(arrangedSubviews: [label, logoutButton])
		view.addSubview(stackView)
		stackView.spacing = 30
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

	}
	
	@objc private func logout() {
		AppDelegate.shared.user.logout()
		if let tabBarController = tabBarController as? TabBarController {
			tabBarController.showLoginViewControllerIfNeeded()
		}
	}
}
