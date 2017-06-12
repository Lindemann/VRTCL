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
	
	var mode: Mode?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Style tableview
		tableView.backgroundColor = Colors.darkGray
		tableView.separatorStyle = .none
		tableView.allowsSelection = false

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(save))
		
		setupModeDependentStuff()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
	
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
