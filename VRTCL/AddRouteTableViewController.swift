//
//  AddRouteTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 12.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

// MARK: - View model
class AddRouteTableViewControllerViewModel: SessionViewModel {

	var isInEditMode: Bool = false
	
	internal var navigationBarTitle: String {
		switch (kind, isInEditMode) {
		case (.sportClimbing, false):
			return "Add Route"
		case (.sportClimbing, true):
			return "Edit Route"
		case (.bouldering, false):
			return "Add Boulder"
		case (.bouldering, true):
			return "Edit Boulder"
		}
	}
	
	internal func leftBarButtonItemWith(target: AddRouteTableViewController) -> UIBarButtonItem {
		switch isInEditMode {
		case true:
			return UIBarButtonItem(title: "Delete", style: .plain, target: target, action: #selector(target.remove))
		case false:
			return UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: #selector(target.cancel))
		}
	}
	
	internal func rightBarButtonItemWith(target: AddRouteTableViewController) -> UIBarButtonItem {
		switch isInEditMode {
		case true:
			return UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(target.done))
		case false:
			return UIBarButtonItem(title: "Save", style: .plain, target: target, action: #selector(target.save))
		}
	}
}

// MARK: - Controller
class AddRouteTableViewController: UITableViewController {
	
	var viewModel = AddRouteTableViewControllerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.backgroundColor = Colors.darkGray
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		
        navigationItem.rightBarButtonItem = viewModel.rightBarButtonItemWith(target: self)
		navigationItem.leftBarButtonItem = viewModel.leftBarButtonItemWith(target: self)
		navigationItem.title = viewModel.navigationBarTitle
		navigationController?.navigationBar.barTintColor = viewModel.navigationBarColor
    }

    // MARK: Table view data source + delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			return styleTableViewCell
		case 1:
			return gradesTableViewCell
		default:
			return UITableViewCell()
		}
    }
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		switch section {
		case 1:
			return gradesHeaderView
		default:
			return nil
		}
	}
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
		view.tintColor = UIColor.red
		let header = view as! UITableViewHeaderFooterView
		header.textLabel?.textColor = UIColor.white
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch section {
		case 1:
			return gradesHeaderView.height
		default:
			return 0
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			return styleTableViewCell.height
		case 1:
			return gradesTableViewCell.height
		default:
			return 0
		}
	}
	
	// MARK: Helper
	
	@objc func save() {
		if let _ = viewModel.climb.style, let _ = viewModel.climb.grade {
			viewModel.climb.index = viewModel.session.climbs?.count
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
	
	@objc func done() {
		if let index = viewModel.climb.index, var climbs = viewModel.session.climbs {
			climbs[index] = viewModel.climb
			viewModel.session.climbs = climbs
		}
		dismiss(animated: true, completion: nil)
	}
	
	@objc func remove() {
		if let index = viewModel.climb.index, var climbs = viewModel.session.climbs {
			climbs.remove(at: index)
			// Updates the index property of climb
			for (index, _) in climbs.enumerated() {
				climbs[index].index = index
			}
			viewModel.session.climbs = climbs
		}
		dismiss(animated: true, completion: nil)
	}
}

// MARK: - Cells + Header
extension AddRouteTableViewControllerViewModel {
	
	internal var system: System {
		switch kind {
		case .sportClimbing:
			return AppDelegate.shared.user.sportClimbingGradeSystem ?? .uiaa
		case .bouldering:
			return AppDelegate.shared.user.boulderingGradeSystem ?? .font
		}
	}
	
	internal var styleTagButtonGrid: TagButtonGrid {
		let tag1 = TagButton(text: Style.onsight.rawValue)
		let tag2 = TagButton(text: Style.flash.rawValue)
		let tag3 = TagButton(text: Style.redpoint.rawValue)
		let tag4 = TagButton(text: Style.attempt.rawValue)
		let tag5 = TagButton(text: Style.toprope.rawValue)
		// Invisible spacing helper: pushes attempt button to the left
		let tag666 = TagButton(text: "                             ")
		tag666.isHidden = true
		var tagButtons: [TagButton]
		switch kind {
		case .sportClimbing:
			tagButtons = [tag1, tag2, tag3, tag4, tag5]
		case .bouldering:
			tagButtons = [tag1, tag2, tag3, tag4, tag666]
		}
		let frame = CGRect(x: 0, y: 0, width: 300, height: 80)
		let tagButtonGrid = TagButtonGrid(frame: frame, items: tagButtons)
		if let style = climb.style {
			tagButtonGrid.selectButtonWith(title: style.rawValue)
		}
		return tagButtonGrid
	}
	
	internal var gradesButtonGrid: ButtonGrid {
		let scale = GradeScales.gradeScaleFor(system: system)
		var items: [UIView] = []
		for grade in scale {
			if grade.isRealGrade == 1 {
				let circleButton = CircleButton(text: grade.value ?? "", color: UIColor(hex: grade.color), appearanceMode: .outlined)
				items.append(circleButton)
				
				if system == .subjective {
					circleButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
				}
			}
		}
		let itemsPerRow = system == .yds ? 4 : 3
		let spacing: CGFloat = system == .yds ? 20 : 40
		if system == .font || system == .hueco {
			items.insert(UIView(), at: 1)
			items.insert(UIView(), at: 1)
		}
		let buttonGrid = ButtonGrid(itemsPerRow: itemsPerRow, items: items, spaceing: spacing)
		
		if let gradeValue = climb.grade?.value {
			buttonGrid.selectButtonWith(title: gradeValue)
		}
		
		return buttonGrid
	}
	
	var gradeSystemTagButton: TagButton {
		var text: String
		switch kind {
		case .sportClimbing:
			text = AppDelegate.shared.user.sportClimbingGradeSystem?.rawValue ?? ""
		case .bouldering:
			text = AppDelegate.shared.user.boulderingGradeSystem?.rawValue ?? ""
		}
		let tagButton = TagButton(text: "Grade System: \(text)", interactionMode: .highlightable)
		return tagButton
	}
}

extension AddRouteTableViewController: ButtonGridDelegate {
	
	private var styleTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = "Style"
		cell.hasBottomSpacing = false
		return cell
	}
	
	private var gradesHeaderView: SessionsTableViewHeaderFooterView {
		let header = SessionsTableViewHeaderFooterView()
		let tagButtonGrid = viewModel.styleTagButtonGrid
		tagButtonGrid.delegate = self
		header.content = tagButtonGrid
		return header
	}
	
	private var gradesTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = "Grades"
		cell.hasTopSpacing = false
		
		let tagButton = viewModel.gradeSystemTagButton
		tagButton.addTarget(self, action: #selector(gradeSystemButtonWasPressed), for: .touchUpInside)
		let gradesButtonGrid = viewModel.gradesButtonGrid
		gradesButtonGrid.delegate = self
		
		let frame = CGRect(x: 0, y: 0, width: 300, height: 80 + gradesButtonGrid.frame.size.height)
		let view = UIView(frame: frame)
		tagButton.center = CGPoint(x: view.center.x, y: tagButton.frame.height/2)
		view.addSubview(tagButton)
		gradesButtonGrid.frame.origin.y = 80
		gradesButtonGrid.center.x = view.center.x
		view.addSubview(gradesButtonGrid)
		
		cell.content = view
		
		return cell
	}
	
	internal func buttonGridButtonWasPressed(sender: UIButton) {
		if let style = Style(rawValue: sender.titleLabel?.text ?? "") {
			viewModel.climb.style = style
		}
		if let grade = GradeScales.gradeFor(system: viewModel.system, value: sender.titleLabel?.text ?? "") {
			viewModel.climb.grade = grade
		}
	}
}

// MARK: - Popover
extension AddRouteTableViewController: UIPopoverPresentationControllerDelegate {
	@objc private func gradeSystemButtonWasPressed(sender: UIButton) {
		let gradeSystemViewController = GradeSystemPopoverViewController()
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

class GradeSystemPopoverViewController: UIViewController, ButtonGridDelegate {
	
	var tableView: UITableView?
	var session: Session = Session(kind: .sportClimbing)
	
	private var tagButtonGrid: TagButtonGrid {
		let tag1 = TagButton(text: System.uiaa.rawValue, presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		let tag2 = TagButton(text: System.french.rawValue, presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		let tag3 = TagButton(text: System.yds.rawValue, presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		let tag4 = TagButton(text: System.font.rawValue, presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		let tag5 = TagButton(text: System.hueco.rawValue, presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		let tag6 = TagButton(text: System.subjective.rawValue, presentingViewBackgroundColor: popoverPresentationController?.backgroundColor)
		
		var tagButtons: [TagButton]
		var frame: CGRect
		var title: String
		switch session.kind {
		case .sportClimbing:
			tagButtons = [tag1, tag2, tag3]
			frame = CGRect(x: 0, y: 0, width: 250, height: 40)
			title = AppDelegate.shared.user.sportClimbingGradeSystem?.rawValue ?? ""
		case .bouldering:
			tagButtons = [tag4, tag5, tag6]
			frame = CGRect(x: 0, y: 0, width: 300, height: 40)
			title = AppDelegate.shared.user.boulderingGradeSystem?.rawValue ?? ""
		}
		let tagButtonGrid = TagButtonGrid(frame: frame, items: tagButtons)
		tagButtonGrid.selectButtonWith(title: title)
		tagButtonGrid.delegate = self
		view.addSubview(tagButtonGrid)
		return tagButtonGrid
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tagButtonGrid.center = view.center
	}
	
	internal func buttonGridButtonWasPressed(sender: UIButton) {
		switch session.kind {
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
