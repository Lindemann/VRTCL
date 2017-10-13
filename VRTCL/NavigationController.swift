//
//  NavigationController.swift
//  VRTCL
//
//  Created by Lindemann on 18/12/15.
//  Copyright © 2015 Lindemann. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationBar.barTintColor = Colors.bar
		navigationBar.tintColor = UIColor.white
		navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}
