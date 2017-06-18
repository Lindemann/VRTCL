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
		
		setupModeDependentStuff()
		setupAddButton()
    }
	
	override func willMove(toParentViewController parent: UIViewController?) {
		super.willMove(toParentViewController: parent)
		self.navigationController?.navigationBar.barTintColor = Colors.barColor
	}
	
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
	
	// MARK: - Helper
	
	func setupModeDependentStuff() {
		guard let kind = viewModel.session?.kind else { return }
		switch kind {
		case .sportClimbing:
			navigationItem.title = "Sport Climbing Session"
			navigationController?.navigationBar.barTintColor = Colors.purple
			addButton = FatButton(origin: CGPoint.zero, color: Colors.purple, title: "Add Route")
		case .bouldering:
			navigationItem.title = "Bouldering Session"
			navigationController?.navigationBar.barTintColor = Colors.skyBlue
			addButton = FatButton(origin: CGPoint.zero, color: Colors.skyBlue, title: "Add Boulder")
		}
	}
	
	@objc func save() {
		navigationController?.popViewController(animated: true)
	}
	
	@objc func addButtonWasPressed() {
		guard let kind = viewModel.session?.kind else { return }
		
		let addRouteTableViewController = AddRouteTableViewController()
		let navigationController = NavigationController(rootViewController: addRouteTableViewController)
		present(navigationController, animated: true, completion: nil)
		
		switch kind {
		case .sportClimbing:
			addRouteTableViewController.mode = .sportClimbing
		case .bouldering:
			addRouteTableViewController.mode = .bouldering
		}
	}
	
	func setupAddButton() {
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
}
