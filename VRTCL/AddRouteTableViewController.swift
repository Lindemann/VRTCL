//
//  AddRouteTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 12.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class AddRouteTableViewController: UITableViewController {
	
	var session: Session? = Session(kind: .sportClimbing)

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.backgroundColor = Colors.darkGray
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(save))
		
		setupSessionKindDependentStuff()
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
	
	private func setupSessionKindDependentStuff() {
		guard let kind = session?.kind else { return }
		switch kind {
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
	
	private var styleTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = "Style"
		
		let tag1 = TagButton(text: Style.flash.rawValue)
		let tag2 = TagButton(text: Style.onsight.rawValue)
		let tag3 = TagButton(text: Style.redpoint.rawValue)
		let tag4 = TagButton(text: Style.attempt.rawValue)
		let tag5 = TagButton(text: Style.toprope.rawValue)
		
		guard let kind = session?.kind else { return cell }
		var tagButtons: [TagButton]
		switch kind {
		case .sportClimbing:
			tagButtons = [tag1, tag2, tag3, tag4, tag5]
		case .bouldering:
			tagButtons = [tag1, tag2, tag3, tag4]
		}
		let frame = CGRect(x: 0, y: 0, width: 300, height: 80)
		let tagButtonGrid = TagButtonGrid(frame: frame, items: tagButtons)
		tagButtonGrid.delegate = self
		cell.content = tagButtonGrid
		
		return cell
	}
	
	private var gradesTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = "Grades"
		
		let frame = CGRect(x: 0, y: 0, width: 300, height: 300)
		let view = UIView(frame: frame)
		//view.backgroundColor = UIColor.green
		cell.content = view
		
		guard let kind = session?.kind else { return cell }
		var text: String
		switch kind {
		case .sportClimbing:
			text = AppDelegate.shared.user.defaultSportClimbingGradeSystem?.rawValue ?? ""
		case .bouldering:
			text = AppDelegate.shared.user.defaultBoulderingGradeSystem?.rawValue ?? ""
		}
		let tagButton = TagButton(text: "Grade System: \(text)", interactionMode: .highlightable)
		tagButton.addTarget(self, action: #selector(gradeSystemButtonWasPressed), for: .touchUpInside)
		tagButton.center = CGPoint(x: view.center.x, y: tagButton.frame.height/2)
		view.addSubview(tagButton)
		
		return cell
	}
	
	internal func buttonGridButtonWasPressed(sender: UIButton) {
		print("🐹🐹🐰🐼")
	}
	
	@objc private func gradeSystemButtonWasPressed(sender: UIButton) {
		let gradeSystemViewController = GradeSystemViewController()
		gradeSystemViewController.modalPresentationStyle = .popover
		gradeSystemViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
		gradeSystemViewController.popoverPresentationController?.delegate = self
		gradeSystemViewController.popoverPresentationController?.sourceView = sender
		gradeSystemViewController.popoverPresentationController?.sourceRect = sender.bounds
		gradeSystemViewController.preferredContentSize = CGSize(width: 320, height: 100)
		gradeSystemViewController.popoverPresentationController?.backgroundColor = Colors.popover
		gradeSystemViewController.tableView = tableView
		gradeSystemViewController.session = session
		present(gradeSystemViewController, animated: true, completion: nil)
	}
	
	func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}
}

class GradeSystemViewController: UIViewController, ButtonGridDelegate {
	
	private var tagButtonGrid: TagButtonGrid?
	var tableView: UITableView?
	var session: Session? = Session(kind: .sportClimbing)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let tag1 = TagButton(text: System.uiaa.rawValue, presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		let tag2 = TagButton(text: System.french.rawValue, presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		let tag3 = TagButton(text: System.yds.rawValue, presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		let tag4 = TagButton(text: System.font.rawValue, presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		let tag5 = TagButton(text: System.hueco.rawValue, presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		let tag6 = TagButton(text: System.subjective.rawValue, presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		guard let kind = session?.kind else { return }
		var tagButtons: [TagButton]
		var frame: CGRect
		var title: String
		switch kind {
		case .sportClimbing:
			tagButtons = [tag1, tag2, tag3]
			frame = CGRect(x: 0, y: 0, width: 250, height: 40)
			title = AppDelegate.shared.user.defaultSportClimbingGradeSystem?.rawValue ?? ""
		case .bouldering:
			tagButtons = [tag4, tag5, tag6]
			frame = CGRect(x: 0, y: 0, width: 300, height: 40)
			title = AppDelegate.shared.user.defaultBoulderingGradeSystem?.rawValue ?? ""
		}
		tagButtonGrid = TagButtonGrid(frame: frame, items: tagButtons)
		tagButtonGrid?.delegate = self
		guard let tagButtonGrid = tagButtonGrid else { return }
		view.addSubview(tagButtonGrid)
		tagButtonGrid.selectButtonWith(title: title)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		tagButtonGrid?.center = view.center
	}
	
	internal func buttonGridButtonWasPressed(sender: UIButton) {
		guard let kind = session?.kind else { return }
		switch kind {
		case .sportClimbing:
			AppDelegate.shared.user.defaultSportClimbingGradeSystem = System(rawValue: sender.titleLabel?.text ?? "")
		case .bouldering:
			AppDelegate.shared.user.defaultBoulderingGradeSystem = System(rawValue: sender.titleLabel?.text ?? "")
		}

		dismiss(animated: true) {
			self.tableView?.reloadData()
		}
	}
}
