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
		
		UINavigationBar.appearance().barTintColor = ColorConstants.BarColor
		UINavigationBar.appearance().tintColor = UIColor.white
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: ColorConstants.LightGray]
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}
