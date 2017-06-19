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
		//tableView.contentInset = UIEdgeInsets(top: (navigationController?.navigationBar.frame.height)!, left: 0, bottom: 0, right: 0)
		tableView.dataSource = self
		tableView.delegate = self
		view.addSubview(tableView)
		
		// Style tableview
		tableView.backgroundColor = Colors.darkGray
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
		
		setupSessionKindDependentStuff()
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
	
    // MARK: - Table view data source
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return climbsTableViewCell
    }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return climbsTableViewCell.height
	}
	
	// MARK: - Helper
	
	func setupSessionKindDependentStuff() {
		switch viewModel.kind {
		case .sportClimbing:
			navigationItem.title = "Sport Climbing Session"
			navigationController?.navigationBar.barTintColor = Colors.purple
			addButton = FatButton(origin: CGPoint.zero, color: Colors.purple, title: "Add Route")
		case .bouldering:
			navigationItem.title = "Bouldering Session"
			navigationController?.navigationBar.barTintColor = Colors.discoBlue
			addButton = FatButton(origin: CGPoint.zero, color: Colors.discoBlue, title: "Add Boulder")
		}
	}
	
	@objc private func addButtonWasPressed() {
		let addRouteTableViewController = AddRouteTableViewController()
		let navigationController = NavigationController(rootViewController: addRouteTableViewController)
		present(navigationController, animated: true, completion: nil)
		addRouteTableViewController.session = viewModel.session
		addRouteTableViewController.climb = Climb()
	}
	
	private func setupAddButton() {
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
	
	@objc private func save() {
		navigationController?.popViewController(animated: true)
	}
}

extension EditSessionViewController: ButtonGridDelegate {
	
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
