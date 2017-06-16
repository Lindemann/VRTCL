//
//  FirstViewController.swift
//  VRTCL
//
//  Created by Lindemann on 11/05/15.
//  Copyright (c) 2015 Lindemann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = Colors.darkGray
		
//		let center = CGPoint(x: view.center.x , y: 200)
//		let circleButton = CircleButton(center: center, diameter: 60, text: "5.15C", color: UIColor(red:0.8, green:1, blue:0.4, alpha:1))
//		view.addSubview(circleButton)
//
//		let center2 = CGPoint(x: view.center.x , y: 200 + 200)
//		let circleButton2 = CircleButton(center: center2, diameter: 40, text: "9", color: UIColor(red:0.8, green:1, blue:0.4, alpha:1))
//		view.addSubview(circleButton2)
//
//		let tagButton = TagButton(text: "redpoint")
//		view.addSubview(tagButton)
//
//		let fatButton = FatButton(origin: CGPoint(x: 50, y: 500), color: UIColor.blue, title: "Login")
//		view.addSubview(fatButton)
//
//		let circleButtonWithText = CircleButtonWithText(mode: .filledMedium, center: CGPoint(x: 60, y: 100), buttonText: "12a+", labelText: "Red Point", color: Colors.skyBlue)
//		view.addSubview(circleButtonWithText)
//
//		let circleButtonWithText2 = CircleButtonWithText(mode: .outlineSmall, center: CGPoint(x: 60, y: 250), buttonText: "12a+", labelText: "Red Point")
//		view.addSubview(circleButtonWithText2)
		
		let buttonGrid = ButtonGrid(origin: CGPoint(x: 60, y: 100), itemsPerRow: 3, items: data(), spaceing: 20)
		buttonGrid.center = view.center
		view.addSubview(buttonGrid)
	}
	
	func data() -> [CircleButtonWithText] {
		var data: [CircleButtonWithText] = []
		for _ in 0...9 {
			let circleButtonWithText = CircleButtonWithText(mode: .filledMedium, center: CGPoint.zero, buttonText: "12a+", labelText: "Red Point", color: Colors.skyBlue)
			data.append(circleButtonWithText)
		}
		return data
	}
}

