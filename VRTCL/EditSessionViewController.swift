//
//  EditSessionTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 12.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

struct EditSessionViewControllerViewModel {
	var session: Session?
	
	var kind: Kind {
		return session?.kind ?? .sportClimbing
	}
	
	var climbsTableViewCellHeading: String {
		return kind == .sportClimbing ? "Routes" : "Boulder"
	}
	
	var climbsButtonGrid: ButtonGrid? {
		guard let climbs = session?.climbs, climbs.count > 0 else { return nil }
		var items: [CircleButtonWithText] = []
		for climb in climbs {
			let circleButtonWithText = CircleButtonWithText(mode: .filledMedium, buttonText: climb.grade?.value ?? "", labelText: climb.style?.rawValue ?? Style.toprope.rawValue, color: climb.grade?.color ?? UIColor.white)
			if climb.style == .attempt || climb.style == .toprope {
				circleButtonWithText.circleButton?.alpha = 0.4
			}
			items.append(circleButtonWithText)
		}
		let buttonGrid = ButtonGrid(itemsPerRow: 3, items: items, spaceing: 30)
		return buttonGrid
	}
	
	var navigationBarTitle: String {
		return kind == .sportClimbing ? "Sport Climbing Session" : "Bouldering Session"
	}
	
	var navigationBarColor: UIColor {
		return kind == .sportClimbing ? Colors.purple : Colors.discoBlue
	}
	
	var addButton: FatButton {
		switch kind {
		case .sportClimbing:
			return FatButton(origin: CGPoint.zero, color: Colors.purple, title: "Add Route")
		case .bouldering:
			return FatButton(origin: CGPoint.zero, color: Colors.discoBlue, title: "Add Boulder")
		}
	}
}

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
	
    // MARK: - Table view data source + delegate
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return climbsTableViewCell
    }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return climbsTableViewCell.height + 120
	}
	
	// MARK: - Helper
	
	@objc private func save() {
		navigationController?.popViewController(animated: true)
	}
}

extension EditSessionViewController {
	
	// MARK: - Add Button
	
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
		addRouteTableViewController.session = viewModel.session
		addRouteTableViewController.climb = Climb()
	}
}

extension EditSessionViewController: ButtonGridDelegate {
	
	// MARK: - Cells
	
	var climbsTableViewCell: SessionsTableViewCell {
		let cell = SessionsTableViewCell()
		cell.heading = viewModel.climbsTableViewCellHeading
		let buttonGrid = viewModel.climbsButtonGrid
		buttonGrid?.delegate = self
		cell.content = buttonGrid
		return cell
	}
	
	func buttonGridButtonWasPressed(sender: UIButton) {
	}
}
