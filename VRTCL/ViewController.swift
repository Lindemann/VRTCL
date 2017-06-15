//
//  FirstViewController.swift
//  VRTCL
//
//  Created by Lindemann on 11/05/15.
//  Copyright (c) 2015 Lindemann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	
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
		
		setupCollectionView()
	}
	
	func data() -> [CircleButtonWithText] {
		var data: [CircleButtonWithText] = []
		for _ in 0...9 {
			let circleButtonWithText = CircleButtonWithText(mode: .filledMedium, center: CGPoint.zero, buttonText: "12a+", labelText: "Red Point", color: Colors.skyBlue)
			data.append(circleButtonWithText)
		}
		return data
	}
	
	func setupCollectionView() {
		let itemSize: CGFloat = 90
		let margin: CGFloat = 20
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.minimumLineSpacing = margin
		flowLayout.minimumInteritemSpacing = margin
		flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
		let frame = CGRect(x: 40, y: 100, width: itemSize * 3 + margin * 3, height: itemSize * 4 + margin * 4)
		collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
		collectionView.delegate = self
		collectionView.dataSource = self
		//collectionView.backgroundColor = UIColor.yellow
		collectionView.backgroundColor = UIColor.clear
		view.addSubview(collectionView)
		collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.nibAndReuseIdentifier)
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return data().count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.nibAndReuseIdentifier, for: indexPath) as! CollectionViewCell
		//cell.backgroundColor = UIColor.brown
		data()[indexPath.row].center = cell.contentView.center
		cell.contentView.addSubview(data()[indexPath.row])
		return cell
	}
	
}

class CollectionViewCell: UICollectionViewCell {
	static let nibAndReuseIdentifier = String(describing: CollectionViewCell.self)
}

