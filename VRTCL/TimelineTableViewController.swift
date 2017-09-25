//
//  TimelineTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 07.07.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

struct TimelineTableViewControllerViewModel {
	
}

class TimelineTableViewController: UITableViewController {
	
	let viewModel = TimelineTableViewControllerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.backgroundColor = Colors.darkGray
		tableView.estimatedRowHeight = UITableViewAutomaticDimension
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.register(TimelineTableViewCell.self, forCellReuseIdentifier: TimelineTableViewCell.nibAndReuseIdentifier)
		tableView.separatorStyle = .none
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.shared.user.sessions.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: TimelineTableViewCell.nibAndReuseIdentifier, for: indexPath) as! TimelineTableViewCell
		var viewModel =  TimelineTableViewCellViewModel()
		let user = User.shared
		viewModel.user = user
		viewModel.session = user.sessions[indexPath.row]
		cell.viewModel = viewModel
        return cell
    }
}
