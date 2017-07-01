
//
//  EditSessionTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 12.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

// MARK: - View model
struct EditSessionViewControllerViewModel {
	var session: Session = Session(kind: .sportClimbing)
	internal var kind: Kind { return session.kind }
	
	internal var navigationBarTitle: String {
		return kind == .sportClimbing ? "Sport Climbing Session" : "Bouldering Session"
	}
	
	internal var navigationBarColor: UIColor {
		return kind == .sportClimbing ? Colors.purple : Colors.discoBlue
	}
	
	internal var addButton: FatButton {
		switch kind {
		case .sportClimbing:
			return FatButton(origin: CGPoint.zero, color: Colors.purple, title: "Add Route")
		case .bouldering:
			return FatButton(origin: CGPoint.zero, color: Colors.discoBlue, title: "Add Boulder")
		}
	}
}

// MARK: - Controller
class EditSessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var viewModel = EditSessionViewControllerViewModel()
	var tableView: UITableView!
	var addButton: FatButton?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Setup tableview
		let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
		let displayWidth: CGFloat = self.view.frame.width
		let displayHeight: CGFloat = self.view.frame.height
		tableView = UITableView(frame: CGRect(x: 0, y: statusBarHeight, width: displayWidth, height: displayHeight - statusBarHeight))
		tableView.dataSource = self
		tableView.delegate = self
		view.addSubview(tableView)
		
		// Style tableview
		tableView.backgroundColor = Colors.darkGray
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
		
		// Style controller
		navigationItem.title = viewModel.navigationBarTitle
		navigationController?.navigationBar.barTintColor = viewModel.navigationBarColor
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
		setupAddButton()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
		if let count = viewModel.session.climbs?.count, count > 0 {
			tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
		}
	}
	
	override func willMove(toParentViewController parent: UIViewController?) {
		super.willMove(toParentViewController: parent)
		self.navigationController?.navigationBar.barTintColor = Colors.bar
	}
	
	// MARK: Table view data source + delegate
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cells.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return cells[indexPath.row]
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if viewModel.session.climbs?.count == 0 && indexPath.row == 0 {
			return 0
		} else {
			return cells[indexPath.row].height
		}
	}
	
	// MARK: Helper
	
	@objc private func save() {
		navigationController?.popViewController(animated: true)
	}
}

// MARK: - Add Button
extension EditSessionViewController {
	
	private func setupAddButton() {
		addButton = viewModel.addButton
		
		guard let tabBar = tabBarController?.tabBar else { return }
		guard let addButton = addButton else { return }
		
		addButton.addTarget(self, action: #selector(addButtonWasPressed), for: .touchUpInside)
		
		view.addSubview(addButton)
		let space: CGFloat = 15
		addButton.translatesAutoresizingMaskIntoConstraints = false
		addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBar.frame.size.height + space)).isActive = true
		addButton.widthAnchor.constraint(greaterThanOrEqualToConstant: view.frame.width - space * 2).isActive = true
	}
	
	@objc private func addButtonWasPressed() {
		let addRouteTableViewController = AddRouteTableViewController()
		let navigationController = NavigationController(rootViewController: addRouteTableViewController)
		present(navigationController, animated: true, completion: nil)
		addRouteTableViewController.viewModel.session = viewModel.session
	}
}

// MARK: - Cells
extension EditSessionViewControllerViewModel {
	
	internal var climbsTableViewCellHeading: String {
		return kind == .sportClimbing ? "Routes" : "Boulder"
	}
	
	internal var climbsButtonGrid: ButtonGrid? {
		guard let climbs = session.climbs, climbs.count > 0 else { return nil }
		var items: [CircleButtonWithText] = []
		for (index, climb) in climbs.enumerated() {
			let circleButtonWithText = CircleButtonWithText(mode: .filledMedium, buttonText: climb.grade?.value ?? "", labelText: climb.style?.rawValue ?? Style.toprope.rawValue, color: climb.grade?.color ?? UIColor.white)
			if climb.style == .attempt || climb.style == .toprope {
				circleButtonWithText.circleButton?.alpha = 0.4
			}
			circleButtonWithText.circleButton?.tag = index
			items.append(circleButtonWithText)
		}
		let buttonGrid = ButtonGrid(itemsPerRow: 3, items: items, spaceing: 30)
		return buttonGrid
	}
	
	internal var moodButtonGrid: ButtonGrid? {
		let smile = CircleButton(diameter: 60, text: "", color: Colors.lightGray, appearanceMode: .outlined, image: #imageLiteral(resourceName: "smile"))
		let nah = CircleButton(diameter: 60, text: "", color: Colors.lightGray, appearanceMode: .outlined, image: #imageLiteral(resourceName: "nah"))
		let dead = CircleButton(diameter: 60, text: "", color: Colors.lightGray, appearanceMode: .outlined, image: #imageLiteral(resourceName: "dead"))
		smile.tag = 0
		nah.tag = 1
		dead.tag = 2
		let items = [smile, nah, dead]
		let buttonGrid = ButtonGrid(itemsPerRow: 3, items: items, spaceing: 40)
		
		if let mood = session.mood {
			switch mood {
			case .good:
				smile.isSelected = true
			case .nah:
				nah.isSelected = true
			case .dead:
				dead.isSelected = true
			}
		}
		
		return buttonGrid
	}
	
	internal var locationButtonGrid: TagButtonGrid {
		let tag1 = TagButton(text: "Gym")
		let tag2 = TagButton(text: "Outdoor")
		let items = [tag1, tag2]
		let frame = CGRect(x: 0, y: 0, width: 250, height: 40)
		let tagButtonGrid = TagButtonGrid(frame: frame, items: items)
		return tagButtonGrid
	}
	
}

extension EditSessionViewController: UITextFieldDelegate {
	
	internal var cells: [SessionsTableViewCell] {
		return [climbsTableViewCell, moodTableViewCell, locationTableViewCell, durationSessionTableViewCell, deleteSessionTableViewCell]
	}
	
	var climbsTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		if let count = viewModel.session.climbs?.count, count > 0 {
			cell.heading = viewModel.climbsTableViewCellHeading
		}
		let buttonGrid = viewModel.climbsButtonGrid
		buttonGrid?.delegate = ClimbButtonPressHelper(viewModel: viewModel, viewController: self)
		cell.content = buttonGrid
		cell.hasBottomSpacing = false
		return cell
	}
	
	var moodTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = "Mood"
		let buttonGrid = viewModel.moodButtonGrid
		buttonGrid?.delegate = MoodButtonPressHelper(viewModel: viewModel, viewController: self)
		cell.content = buttonGrid
		cell.hasBottomSpacing = false
		return cell
	}
	
	var locationTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = "Location"
		let tagButtonGrid = viewModel.locationButtonGrid
		tagButtonGrid.delegate = LocationButtonPressHelper(viewModel: viewModel, viewController: self)
		
		let textField = FatTextField(origin: CGPoint.zero)
		textField.delegate = self
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
		tableView.addGestureRecognizer(tapGestureRecognizer)
		
		let frame = CGRect(x: 0, y: 0, width: 330, height: tagButtonGrid.frame.height + textField.frame.height + 20)
		let view = UIView(frame: frame)
		tagButtonGrid.frame.origin.y = 0
		tagButtonGrid.center.x = view.center.x
		textField.center.x = view.center.x
		textField.frame.origin.y = view.frame.height - textField.frame.height
		view.addSubview(tagButtonGrid)
		view.addSubview(textField)
		cell.content = view
		cell.hasBottomSpacing = false
		return cell
	}
	
	var durationSessionTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = "Duration"
		let durationView = DurationView()
		cell.content = durationView
		return cell
	}
	
	var deleteSessionTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		let tagButton = TagButton(text: "Delete Session", color: Colors.watermelon, interactionMode: .highlightable)
		tagButton.addTarget(self, action: #selector(deleteSession), for: .touchUpInside)
		cell.content = tagButton
		return cell
	}
	
	internal class ClimbButtonPressHelper: ButtonGridButtonPressHelper, ButtonGridDelegate {
		func buttonGridButtonWasPressed(sender: UIButton) {
			guard let climbs = viewModel.session.climbs else { return }
			let addRouteTableViewController = AddRouteTableViewController()
			let navigationController = NavigationController(rootViewController: addRouteTableViewController)
			viewController.present(navigationController, animated: true, completion: nil)
			addRouteTableViewController.viewModel.session = viewModel.session
			addRouteTableViewController.viewModel.climb = climbs[sender.tag]
			addRouteTableViewController.viewModel.isInEditMode = true
			switch viewModel.kind {
			case .sportClimbing:
				AppDelegate.shared.user.sportClimbingGradeSystem = addRouteTableViewController.viewModel.climb.grade?.system
			case .bouldering:
				AppDelegate.shared.user.boulderingGradeSystem = addRouteTableViewController.viewModel.climb.grade?.system
			}
		}
	}
	
	internal class MoodButtonPressHelper: ButtonGridButtonPressHelper, ButtonGridDelegate {
		func buttonGridButtonWasPressed(sender: UIButton) {
			switch sender.tag {
			case 0:
				viewModel.session.mood = .good
			case 1:
				viewModel.session.mood = .nah
			case 2:
				viewModel.session.mood = .dead
			default:
				return
			}
		}
	}
	
	internal class LocationButtonPressHelper: ButtonGridButtonPressHelper, ButtonGridDelegate {
		func buttonGridButtonWasPressed(sender: UIButton) {
			
		}
	}
	
	@objc func deleteSession() {
		let alertController = UIAlertController(title: "Really Delete Session?!", message: nil, preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
			return
		}
		let DeleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
			self?.navigationController?.popViewController(animated: true)
		}
		alertController.addAction(DeleteAction)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}
}

internal class ButtonGridButtonPressHelper {
	let viewModel: EditSessionViewControllerViewModel
	let viewController: EditSessionViewController
	init(viewModel: EditSessionViewControllerViewModel, viewController: EditSessionViewController) {
		self.viewModel = viewModel
		self.viewController = viewController
	}
}

// MARK:  - Handle text field action
extension EditSessionViewController {
	@objc func tap() {
		view.endEditing(true)
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		let pointInTable: CGPoint = textField.superview!.convert(textField.frame.origin, to: tableView)
		var contentOffset: CGPoint = tableView.contentOffset
		contentOffset.y = pointInTable.y - 200
		UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { [weak self] in
			self?.tableView.contentOffset = contentOffset
		})
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		view.endEditing(true)
		return true
	}
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		view.endEditing(true)
	}
}


