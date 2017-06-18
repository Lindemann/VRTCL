//
//  AddRouteTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 12.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

struct AddRouteTableViewControllerViewModel {
	
}

class AddRouteTableViewController: UITableViewController {
	
	enum Mode {
		case sportClimbing, bouldering
	}
	
	var mode: Mode? = .sportClimbing

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.backgroundColor = Colors.darkGray
		tableView.separatorStyle = .none
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
        return 2
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			return styleTableViewCell
		case 1:
			return gradesTableViewCell
		default:
			return UITableViewCell()
		}
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
		case 0:
			return styleTableViewCell.height
		case 1:
			return gradesTableViewCell.height + gradesTableViewCell.spacing
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
			navigationController?.navigationBar.barTintColor = Colors.discoBlue
		}
	}
	
	@objc func save() {
		dismiss(animated: true, completion: nil)
	}
}

extension AddRouteTableViewController: ButtonGridDelegate, UIPopoverPresentationControllerDelegate {
	
	var styleTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = "Style"
		
		let tag1 = TagButton(text: "Flash")
		let tag2 = TagButton(text: "On Sight")
		let tag3 = TagButton(text: "Redpoint")
		let tag4 = TagButton(text: "Attempt")
		let tag5 = TagButton(text: "Toprope")
		let tagButtons = [tag1, tag2, tag3, tag4, tag5]
		let frame = CGRect(x: 0, y: 0, width: 300, height: 80)
		let tagButtonGrid = TagButtonGrid(frame: frame, items: tagButtons)
		tagButtonGrid.delegate = self
		cell.content = tagButtonGrid
		
		return cell
	}
	
	var gradesTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = "Grades"
		
		let frame = CGRect(x: 0, y: 0, width: 300, height: 300)
		let view = UIView(frame: frame)
		//view.backgroundColor = UIColor.green
		cell.content = view
		
		let tagButton = TagButton(text: "Grade System: UIAA", interactionMode: .highlightable)
		tagButton.addTarget(self, action: #selector(gradeSystemButtonWasPressed), for: .touchUpInside)
		tagButton.center = CGPoint(x: view.center.x, y: tagButton.frame.height/2)
		view.addSubview(tagButton)
		
		return cell
	}
	
	func buttonGridButtonWasPressed(sender: UIButton) {
		print("🐹🐹🐰🐼")
	}
	
	@objc func gradeSystemButtonWasPressed(sender: UIButton) {
		let gradeSystemViewController = GradeSystemViewController()
		gradeSystemViewController.modalPresentationStyle = .popover
		gradeSystemViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
		gradeSystemViewController.popoverPresentationController?.delegate = self
		gradeSystemViewController.popoverPresentationController?.sourceView = sender
		gradeSystemViewController.popoverPresentationController?.sourceRect = sender.bounds
		gradeSystemViewController.preferredContentSize = CGSize(width: 320, height: 100)
		gradeSystemViewController.popoverPresentationController?.backgroundColor = Colors.popover
		present(gradeSystemViewController, animated: true, completion: nil)
	}
	
	func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}
	
}

class GradeSystemViewController: UIViewController, ButtonGridDelegate {
	
	var tagButtonGrid: TagButtonGrid?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let tag1 = TagButton(text: "UIAA", presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		let tag2 = TagButton(text: "French", presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		let tag3 = TagButton(text: "YDS", presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		let tagButtons = [tag1, tag2, tag3]
		let frame = CGRect(x: 0, y: 0, width: 250, height: 40)
		tagButtonGrid = TagButtonGrid(frame: frame, items: tagButtons)
		tagButtonGrid?.delegate = self
		guard let tagButtonGrid = tagButtonGrid else { return }
		view.addSubview(tagButtonGrid)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		tagButtonGrid?.center = view.center
	}
	
	func buttonGridButtonWasPressed(sender: UIButton) {
		print("🐹🐹🐰🐼")
		dismiss(animated: true, completion: nil)
	}
}
