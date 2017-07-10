//
//  ButtonGrid.swift
//  VRTCL
//
//  Created by Lindemann on 15.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

protocol ButtonGridDelegate {
	func buttonGridButtonWasPressed(sender: UIButton)
}

class ButtonGrid: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var itemsPerRow: Int!
	var spaceing: CGFloat!
	var items: [UIView]! {
		didSet {
			for item in items {
				if let button = item as? UIButton {
					button.addTarget(self, action: #selector(buttonWasPressed), for: .touchUpInside)
				} else if let circleButton = (item as? CircleButtonWithText)?.circleButton {
					circleButton.addTarget(self, action: #selector(buttonWasPressed), for: .touchUpInside)
				}
			}
		}
	}
	
	var itemSize: CGFloat {
		guard items.count > 0 else {
			print("⚠️ ButtonGrid has no items!")
			return 20
		}
		return items[0].frame.size.width
	}
	
	var delegate: ButtonGridDelegate?
	
	internal var collectionView: UICollectionView!
	
	init(origin: CGPoint = CGPoint.zero, itemsPerRow: Int, items: [UIView], spaceing: CGFloat) {
		self.itemsPerRow = itemsPerRow
		self.spaceing = spaceing
		self.items = items
		super.init(frame: CGRect(origin: origin, size: size(itemsPerRow: itemsPerRow, spaceing: spaceing, items: items)))
		setupCollectionView()
		// TODO: Fix me!
		defer {
			self.items = items
		}
	}
	
	internal init(frame: CGRect, items: [UIView]) {
		defer {
			self.items = items
		}
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func size(itemsPerRow: Int, spaceing: CGFloat, items: [UIView]) -> CGSize {
		guard items.count > 0 else { return CGSize(width: 20, height: 20) }
		let itemSize: CGFloat = self.itemSize
		let itemsPerColum: Int = items.count % itemsPerRow == 0 ? items.count / itemsPerRow : items.count / itemsPerRow + 1
		let size = CGSize(width: itemSize * CGFloat(itemsPerRow) + spaceing * CGFloat(itemsPerRow - 1), height: itemSize * CGFloat(itemsPerColum) + spaceing * CGFloat(itemsPerColum - 1))
		return size
	}
	
	private func setupCollectionView() {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.minimumLineSpacing = spaceing
		flowLayout.minimumInteritemSpacing = spaceing
		let itemSize: CGFloat = self.itemSize
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
	
	func selectButtonWith(title: String) {
		guard let items = items else { return }
		for item in items {
			if let button = item as? UIButton {
				button.isSelected = button.titleLabel?.text == title ? true : false
			} else if let circleButton = (item as? CircleButtonWithText)?.circleButton {
				circleButton.isSelected = circleButton.titleLabel?.text == title ? true : false
			}
		}
	}
	
	@objc func buttonWasPressed(sender: UIButton) {
		let tmpSelectionState = sender.isSelected
		guard let items = items else { return }
		for item in items {
			if let button = item as? UIButton {
				button.isSelected = false
			} else if let circleButton = (item as? CircleButtonWithText)?.circleButton {
				circleButton.isSelected = false
			}
		}
		sender.isSelected = tmpSelectionState
		delegate?.buttonGridButtonWasPressed(sender: sender)
	}
}

class TagButtonGrid: ButtonGrid, UICollectionViewDelegateFlowLayout {
	
	override init(frame: CGRect, items: [UIView]) {
		super.init(frame: frame, items: items)
		setupCollectionView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupCollectionView() {
		let flowLayout = CenterAlignedCollectionViewFlowLayout()
		let itemSize: CGFloat = items[0].frame.size.width
		let spacing: CGFloat = 14
		flowLayout.minimumLineSpacing = spacing
		flowLayout.minimumInteritemSpacing = spacing
		flowLayout.interItemSpacing = spacing
		flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
		collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = UIColor.clear
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
		addSubview(collectionView)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: items[indexPath.row].frame.size.width, height: items[indexPath.row].frame.size.height)
	}
}

// Source: https://stackoverflow.com/a/38254368/647644
class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
	
	var interItemSpacing: CGFloat = 10
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		
		let attributes = super.layoutAttributesForElements(in: rect)
		
		// Constants
		let leftPadding: CGFloat = 0
		let interItemSpacing: CGFloat = self.interItemSpacing
		
		// Tracking values
		var leftMargin: CGFloat = leftPadding // Modified to determine origin.x for each item
		var maxY: CGFloat = -1.0 // Modified to determine origin.y for each item
		var rowSizes: [[CGFloat]] = [] // Tracks the starting and ending x-values for the first and last item in the row
		var currentRow: Int = 0 // Tracks the current row
		attributes?.forEach { layoutAttribute in
			
			// Each layoutAttribute represents its own item
			if layoutAttribute.frame.origin.y >= maxY {
				
				// This layoutAttribute represents the left-most item in the row
				leftMargin = leftPadding
				
				// Register its origin.x in rowSizes for use later
				if rowSizes.count == 0 {
					// Add to first row
					rowSizes = [[leftMargin, 0]]
				} else {
					// Append a new row
					rowSizes.append([leftMargin, 0])
					currentRow += 1
				}
			}
			
			layoutAttribute.frame.origin.x = leftMargin
			
			leftMargin += layoutAttribute.frame.width + interItemSpacing
			maxY = max(layoutAttribute.frame.maxY, maxY)
			
			// Add right-most x value for last item in the row
			rowSizes[currentRow][1] = leftMargin - interItemSpacing
		}
		
		// At this point, all cells are left aligned
		// Reset tracking values and add extra left padding to center align entire row
		leftMargin = leftPadding
		maxY = -1.0
		currentRow = 0
		attributes?.forEach { layoutAttribute in
			
			// Each layoutAttribute is its own item
			if layoutAttribute.frame.origin.y >= maxY {
				
				// This layoutAttribute represents the left-most item in the row
				leftMargin = leftPadding
				
				// Need to bump it up by an appended margin
				let rowWidth = rowSizes[currentRow][1] - rowSizes[currentRow][0] // last.x - first.x
				let appendedMargin = (collectionView!.frame.width - leftPadding  - rowWidth - leftPadding) / 2
				leftMargin += appendedMargin
				
				currentRow += 1
			}
			
			layoutAttribute.frame.origin.x = leftMargin
			
			leftMargin += layoutAttribute.frame.width + interItemSpacing
			maxY = max(layoutAttribute.frame.maxY, maxY)
		}
		
		return attributes
	}
}
