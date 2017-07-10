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
		
		tableView.separatorColor = Colors.lightGray
		tableView.separatorStyle = .none
//		tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		dch_checkDeallocation()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
		viewModel.kind = AppDelegate.shared.user.sessions[indexPath.row].kind
		viewModel.location = AppDelegate.shared.user.sessions[indexPath.row].location?.name ?? "?"
		viewModel.numberOfClimbs = AppDelegate.shared.user.sessions[indexPath.row].climbs?.count ?? 0
		viewModel.bestEffort = "\(Statistics.bestEffort(session: AppDelegate.shared.user.sessions[indexPath.row])?.grade?.value ?? "0")"
		viewModel.duration = AppDelegate.shared.user.sessions[indexPath.row].duration ?? 0
		viewModel.climbs = AppDelegate.shared.user.sessions[indexPath.row].climbs ?? []
		cell.viewModel = viewModel
        return cell
    }
}
