//
//  TimelineTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 07.07.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class TimelineTableViewControllerViewModel {
	var timelineTableViewController: TimelineTableViewController
	var timelineDataArray: [TimelineData] = []
	
	init(timelineTableViewController: TimelineTableViewController) {
		self.timelineTableViewController = timelineTableViewController
	}
	
	func fetchData() {
		if mode == .friend {
			guard let friend = friend else { return }
			self.timelineDataArray = TimelineBuilder(users: [friend]).timelineDataArray
			self.timelineTableViewController.tableView.reloadData()
			self.refreshControl.endRefreshing()
			return
		}
		if mode == .me {
			self.timelineDataArray = TimelineBuilder(users: [User.shared]).timelineDataArray
			self.timelineTableViewController.tableView.reloadData()
			self.refreshControl.endRefreshing()
			return
		}
		if mode == .everyone {
			// To remove the .me user data before the request was successfull
			self.timelineDataArray = TimelineBuilder(users: everyone).timelineDataArray
			self.timelineTableViewController.tableView.reloadData()
			
			APIController.following { (success, error, users) in
				if success, let users = users {
					self.everyone = users
					self.everyone.append(User.shared)
					self.timelineDataArray = TimelineBuilder(users: self.everyone).timelineDataArray
					self.timelineTableViewController.tableView.reloadData()
				}
				self.refreshControl.endRefreshing()
			}
		}
	}
	
	lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
		refreshControl.tintColor = UIColor.white
		return refreshControl
	}()
	
	@objc func refresh(sender: UIRefreshControl) {
		fetchData()
	}
	
	enum Mode {
		case everyone
		case me
		case friend
	}
	
	var friend: User?
	var everyone: [User] = []
	
	var mode: Mode = .everyone
	
	lazy var segmentedControl: UISegmentedControl = {
		let segmentedControl = UISegmentedControl(items: ["Everyone", "Me"])
		segmentedControl.selectedSegmentIndex = 0
		segmentedControl.tintColor = Colors.lightGray
		segmentedControl.addTarget(self, action: #selector(changeKind(sender:)), for: .valueChanged)
		segmentedControl.setWidth(120, forSegmentAt: 0)
		segmentedControl.setWidth(120, forSegmentAt: 1)
		return segmentedControl
	} ()
	
	@objc private func changeKind(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			mode = .everyone
			fetchData()
		default:
			mode = .me
			fetchData()
		}
	}
	
	struct TimelineData {
		let user: User
		let session: Session
	}
	
	class TimelineBuilder {
		var users: [User]
		
		init(users: [User]) {
			self.users = users
		}
		
		var timelineDataArray: [TimelineData] {
			var timelineDataArray: [TimelineData] = []
			for user in users {
				for session in user.sessions {
					let timelineData = TimelineData(user: user, session: session)
					timelineDataArray.append(timelineData)
				}
			}
			
			timelineDataArray.sort { (timelineDataA, timelineDataB) -> Bool in
				guard let dateA = timelineDataA.session.date, let dateB = timelineDataB.session.date else { return false }
				if dateA > dateB { return true }
				return false
			}
			
			return timelineDataArray
		}
	}
}

class TimelineTableViewController: UITableViewController {
	
	var viewModel: TimelineTableViewControllerViewModel!
	
	enum Mode {
		case timeline // for the timeline tab
		case friend // friend detail in friends tab
	}
	var friend: User?
	var mode: Mode = .timeline

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.backgroundColor = Colors.darkGray
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(TimelineTableViewCell.self, forCellReuseIdentifier: TimelineTableViewCell.nibAndReuseIdentifier)
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		
		viewModel = TimelineTableViewControllerViewModel(timelineTableViewController: self)
		tableView.addSubview(viewModel.refreshControl)
		if mode == .friend {
			if let friend = friend {
				viewModel.mode = .friend
				viewModel.friend = friend
				navigationItem.title = friend.name
			}
		} else {
			navigationItem.titleView = viewModel.segmentedControl
		}
		viewModel.fetchData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.fetchData()
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.timelineDataArray.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = TimelineTableViewCell()
		let timelineData = viewModel.timelineDataArray[indexPath.row]
		var timelineViewModel =  TimelineTableViewCellViewModel()
		timelineViewModel.user = timelineData.user
		timelineViewModel.session = timelineData.session
		cell.viewModel = timelineViewModel
        return cell
    }
}



































