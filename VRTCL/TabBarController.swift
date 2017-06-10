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

		UITabBar.appearance().tintColor = UIColor.white
		UITabBar.appearance().barTintColor = ColorConstants.BarColor

//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().backgroundImage = UIImage()
//        UITabBar.appearance().backgroundColor = ColorConstants.VeryDarkGray
	}
}
