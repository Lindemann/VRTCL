//
//  AddRouteTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 12.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

// MARK: - View model
struct AddRouteTableViewControllerViewModel {
	var session: Session = Session(kind: .sportClimbing)
	var climb: Climb = Climb()
	var kind: Kind { return session.kind }
}

// MARK: - Controller
class AddRouteTableViewController: UITableViewController {
	
	var viewModel = AddRouteTableViewControllerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.backgroundColor = Colors.darkGray
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
		
		setupSessionKindDependentStuff()
    }

    // MARK: Table view data source + delegate

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
	
	// MARK: Helper
	
	private func setupSessionKindDependentStuff() {
		switch viewModel.kind {
		case .sportClimbing:
			navigationItem.title = "Add Route"
			navigationController?.navigationBar.barTintColor = Colors.purple
		case .bouldering:
			navigationItem.title = "Add Boulder"
			navigationController?.navigationBar.barTintColor = Colors.discoBlue
		}
	}
	
	@objc func save() {
		if let _ = viewModel.climb.style, let _ = viewModel.climb.grade {
			viewModel.session.climbs?.append(viewModel.climb)
			dismiss(animated: true, completion: nil)
		} else {
			let generator = UIImpactFeedbackGenerator(style: .heavy)
			generator.impactOccurred()
		}
	}
	
	@objc func cancel() {
		dismiss(animated: true, completion: nil)
	}
}

// MARK: - Cells + Header
extension AddRouteTableViewController: ButtonGridDelegate {
	
	private var styleTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = "Style"
		
		let tag1 = TagButton(text: Style.flash.rawValue)
		let tag2 = TagButton(text: Style.onsight.rawValue)
		let tag3 = TagButton(text: Style.redpoint.rawValue)
		let tag4 = TagButton(text: Style.attempt.rawValue)
		let tag5 = TagButton(text: Style.toprope.rawValue)
		let tag666 = TagButton(text: "                             ")
		tag666.isHidden = true
		
		var tagButtons: [TagButton]
		switch viewModel.kind {
		case .sportClimbing:
			tagButtons = [tag1, tag2, tag3, tag4, tag5]
		case .bouldering:
			tagButtons = [tag1, tag2, tag3, tag4, tag666]
		}
		let frame = CGRect(x: 0, y: 0, width: 300, height: 80)
		let tagButtonGrid = TagButtonGrid(frame: frame, items: tagButtons)
		tagButtonGrid.delegate = self
		cell.content = tagButtonGrid
		
		if let style = viewModel.climb.style {
			tagButtonGrid.selectButtonWith(title: style.rawValue)
		}
		
		return cell
	}
	
	private var gradesTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = "Grades"
		
		var text: String
		switch viewModel.kind {
		case .sportClimbing:
			text = AppDelegate.shared.user.sportClimbingGradeSystem?.rawValue ?? ""
		case .bouldering:
			text = AppDelegate.shared.user.boulderingGradeSystem?.rawValue ?? ""
		}
		let tagButton = TagButton(text: "Grade System: \(text)", interactionMode: .highlightable)
		tagButton.addTarget(self, action: #selector(gradeSystemButtonWasPressed), for: .touchUpInside)
		
		let gradesButtonGrid = self.gradesButtonGrid()
		gradesButtonGrid?.delegate = self
		
		let frame = CGRect(x: 0, y: 0, width: 300, height: 80 + (gradesButtonGrid?.frame.size.height ?? 0))
		let view = UIView(frame: frame)
		tagButton.center = CGPoint(x: view.center.x, y: tagButton.frame.height/2)
		view.addSubview(tagButton)
		if let gradesButtonGrid = gradesButtonGrid {
			gradesButtonGrid.frame.origin.y = 80
			gradesButtonGrid.center.x = view.center.x
			view.addSubview(gradesButtonGrid)
		}
		cell.content = view
		
		return cell
	}
	
	private func gradesButtonGrid() -> ButtonGrid? {
		let scale = GradeScales.gradeScaleFor(system: currentSystem())
		var items: [UIView] = []
		for grade in scale {
			if grade.isRealGrade == true {
				let circleButton = CircleButton(text: grade.value ?? "", color: grade.color ?? UIColor.white, appearanceMode: .outlined)
				items.append(circleButton)
				
				if currentSystem() == .subjective {
					circleButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
				}
			}
		}
		let itemsPerRow = currentSystem() == .yds ? 4 : 3
		let spacing: CGFloat = currentSystem() == .yds ? 20 : 40
		if currentSystem() == .font {
			items.insert(UIView(), at: 1)
			items.insert(UIView(), at: 1)
		}
		let buttonGrid = ButtonGrid(itemsPerRow: itemsPerRow, items: items, spaceing: spacing)
		return buttonGrid
	}
	
	internal func buttonGridButtonWasPressed(sender: UIButton) {
		if let style = Style(rawValue: sender.titleLabel?.text ?? "") {
			viewModel.climb.style = style
		}
		if let grade = GradeScales.gradeFor(system: currentSystem(), value: sender.titleLabel?.text ?? "") {
			viewModel.climb.grade = grade
		}
	}
	
	private func currentSystem() -> System {
		switch viewModel.kind {
		case .sportClimbing:
			return AppDelegate.shared.user.sportClimbingGradeSystem ?? .uiaa
		case .bouldering:
			return AppDelegate.shared.user.boulderingGradeSystem ?? .font
		}
	}
}

// MARK: - Popover
extension AddRouteTableViewController: UIPopoverPresentationControllerDelegate {
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
		gradeSystemViewController.session = viewModel.session
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
			title = AppDelegate.shared.user.sportClimbingGradeSystem?.rawValue ?? ""
		case .bouldering:
			tagButtons = [tag4, tag5, tag6]
			frame = CGRect(x: 0, y: 0, width: 300, height: 40)
			title = AppDelegate.shared.user.boulderingGradeSystem?.rawValue ?? ""
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
			AppDelegate.shared.user.sportClimbingGradeSystem = System(rawValue: sender.titleLabel?.text ?? "")
		case .bouldering:
			AppDelegate.shared.user.boulderingGradeSystem = System(rawValue: sender.titleLabel?.text ?? "")
		}
		
		dismiss(animated: true) { [weak self] in
			self?.tableView?.reloadData()
		}
	}
}
