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
		return cells[indexPath.row].height
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
		return buttonGrid
	}
}

extension EditSessionViewController {
	
	internal var cells: [SessionsTableViewCell] {
		var tmpCells = [moodTableViewCell]
		if let count = viewModel.session.climbs?.count, count > 0 {
			tmpCells.insert(climbsTableViewCell, at: 0)
			return tmpCells
		} else {
			return tmpCells
		}
	}
	
	var climbsTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = viewModel.climbsTableViewCellHeading
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
}

internal class ButtonGridButtonPressHelper {
	let viewModel: EditSessionViewControllerViewModel
	let viewController: EditSessionViewController
	init(viewModel: EditSessionViewControllerViewModel, viewController: EditSessionViewController) {
		self.viewModel = viewModel
		self.viewController = viewController
	}
}
