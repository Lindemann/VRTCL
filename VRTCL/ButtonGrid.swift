//
//  ButtonGrid.swift
//  VRTCL
//
//  Created by Lindemann on 15.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class ButtonGrid: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var itemsPerRow: Int!
	var items: [UIView]!
	var spaceing: CGFloat!
	
	private var collectionView: UICollectionView!
	
	init(origin: CGPoint, itemsPerRow: Int, items: [UIView], spaceing: CGFloat) {
		self.itemsPerRow = itemsPerRow
		self.items = items
		self.spaceing = spaceing
		super.init(frame: CGRect(origin: origin, size: size(itemsPerRow: itemsPerRow, spaceing: spaceing, items: items)))
		setupCollectionView()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func size(itemsPerRow: Int, spaceing: CGFloat, items: [UIView]) -> CGSize {
		let itemSize: CGFloat = items[0].frame.size.width
		let itemsPerColum: Int = items.count % itemsPerRow == 0 ? items.count / itemsPerRow : items.count / itemsPerRow + 1
		let size = CGSize(width: itemSize * CGFloat(itemsPerRow) + spaceing * CGFloat(itemsPerRow - 1), height: itemSize * CGFloat(itemsPerColum) + spaceing * CGFloat(itemsPerColum - 1))
		return size
	}
	
	private func setupCollectionView() {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.minimumLineSpacing = spaceing
		flowLayout.minimumInteritemSpacing = spaceing
		let itemSize: CGFloat = items[0].frame.size.width
		flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
		collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = UIColor.clear
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
		addSubview(collectionView)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
		let item = items[indexPath.row]
		item.center = cell.contentView.center
		cell.contentView.addSubview(item)
		return cell
	}
}
