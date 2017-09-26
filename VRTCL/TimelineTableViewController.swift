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
		let cell = TimelineTableViewCell()
		var viewModel =  TimelineTableViewCellViewModel()
		let user = User.shared
		viewModel.user = user
		viewModel.session = user.sessions[indexPath.row]
		cell.viewModel = viewModel
        return cell
    }
}

class TimelineBuilder {
    var users: [User]
    
    init(users: [User]) {
        self.users = users
    }
    
    var sessions: [Session] {
        var sessions: [Session] = []
        for user in users {
            sessions += user.sessions
        }
        sessions += User.shared.sessions
        
        sessions.sort { (session1, session2) -> Bool in
            guard let date1 = session1.date, let date2 = session2.date else { return false }
            if date1 > date2 { return true }
            return false
        }
        
        return sessions
    }
}




































