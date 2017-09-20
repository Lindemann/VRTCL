//
//  TabBarController.swift
//  VRTCL
//
//  Created by Lindemann on 18/12/15.
//  Copyright © 2015 Lindemann. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()

		tabBar.tintColor = UIColor.white
		tabBar.barTintColor = Colors.bar
	}
	
	override func viewDidAppear(_ animated: Bool) {
		showLoginViewControllerIfNeeded()
	}
	
	func showLoginViewControllerIfNeeded() {
		if !AppDelegate.shared.user.isAuthenticated {
			let loginViewControler = LoginViewController()
			let navigationViewController = NavigationController(rootViewController: loginViewControler)
			present(navigationViewController, animated: true, completion: nil)
		}
	}
}
