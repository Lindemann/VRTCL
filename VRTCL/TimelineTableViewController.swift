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
        return 2
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: TimelineTableViewCell.nibAndReuseIdentifier, for: indexPath) as! TimelineTableViewCell
		
        return cell
    }
}
