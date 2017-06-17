//
//  AddRouteTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 12.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class AddRouteTableViewController: UITableViewController {
	
	enum Mode {
		case sportClimbing, bouldering
	}
	
	var mode: Mode? = .sportClimbing

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Style tableview
		tableView.backgroundColor = Colors.darkGray
		//tableView.separatorStyle = .none
		tableView.allowsSelection = false
		
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(save))
		
		setupModeDependentStuff()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			return styleTableViewCell
		default:
			return UITableViewCell()
		}
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
		case 0:
			return styleTableViewCell.height
		default:
			return 0
		}
	}
	
	// MARK: - Helper
	
	func setupModeDependentStuff() {
		guard let mode = self.mode else { return }
		switch mode {
		case .sportClimbing:
			navigationItem.title = "Add Route"
			navigationController?.navigationBar.barTintColor = Colors.purple
		case .bouldering:
			navigationItem.title = "Add Boulder"
			navigationController?.navigationBar.barTintColor = Colors.skyBlue
		}
	}
	
	@objc func save() {
		dismiss(animated: true, completion: nil)
	}
}

extension AddRouteTableViewController: ButtonGridDelegate {
	
	var styleTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = "Style"
		
		let tag1 = TagButton(text: "Flash")
		let tag2 = TagButton(text: "On Sight")
		let tag3 = TagButton(text: "Red Point")
		let tag4 = TagButton(text: "Attempt")
		let tag5 = TagButton(text: "Toprope")
		let tagButtons = [tag1, tag2, tag3, tag4, tag5]
		let frame = CGRect(x: 0, y: 0, width: 300, height: 80)
		let tagButtonGrid = TagButtonGrid(frame: frame, items: tagButtons)
		tagButtonGrid.delegate = self
		cell.content = tagButtonGrid
		
		return cell
	}
	
	func buttonGridButtonWasPressed(sender: UIButton) {
		print("🐹🐹🐰🐼")
	}
}
