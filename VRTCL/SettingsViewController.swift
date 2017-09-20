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
	
	var viewModel = SettingsViewControllerViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = Colors.darkGray
		navigationItem.title = "Settings"
		setup()
	}
	
	private func setup() {
		
		let logoutButton = FatButton(color: Colors.purple, title: "Logout")
		logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
		
		let stackView = UIStackView(arrangedSubviews: [logoutButton])
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
