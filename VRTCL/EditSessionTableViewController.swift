//
//  EditSessionTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 12.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class EditSessionTableViewController: UITableViewController {
	
	enum Mode {
		case sportClimbing, bouldering
	}
	
	var mode: Mode?
	
	var addButton: FatButton?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.backgroundColor = Colors.darkGray
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		guard let mode = self.mode else { return }
		switch mode {
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
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		setupAddButton()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		addButton?.removeFromSuperview()
	}
	
	override func willMove(toParentViewController parent: UIViewController?) {
		super.willMove(toParentViewController: parent)
		
		self.navigationController?.navigationBar.barTintColor = Colors.barColor
		addButton?.removeFromSuperview()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	@objc func save() {
		navigationController?.popViewController(animated: true)
	}
	
	@objc func addButtonWasPressed() {
		guard let mode = self.mode else { return }
		
		let addRouteTableViewController = AddRouteTableViewController()
		let navigationController = NavigationController(rootViewController: addRouteTableViewController)
		self.navigationController?.present(navigationController, animated: true, completion: {})
		
		switch mode {
		case .sportClimbing:
			addRouteTableViewController.mode = .sportClimbing
		case .bouldering:
			addRouteTableViewController.mode = .bouldering
		}
	}
	
	func setupAddButton() {
		guard let navigationController = self.navigationController else { return }
		guard let tabBar = tabBarController?.tabBar else { return }
		guard let addButton = addButton else { return }
		
		addButton.addTarget(self, action: #selector(addButtonWasPressed), for: .touchUpInside)
		
		navigationController.view.addSubview(addButton)
		
		let space: CGFloat = 15
		addButton.translatesAutoresizingMaskIntoConstraints = false
		addButton.centerXAnchor.constraint(equalTo: navigationController.view.centerXAnchor).isActive = true
		addButton.bottomAnchor.constraint(equalTo: navigationController.view.bottomAnchor, constant: -(tabBar.frame.size.height + space)).isActive = true
		addButton.widthAnchor.constraint(greaterThanOrEqualToConstant: navigationController.view.frame.width - space * 2).isActive = true
		
		addButton.alpha = 0
		UIView.animate(withDuration: 0.4, animations: {
			addButton.alpha = 1
		}, completion: nil)
	}
}
