//
//  FriendsTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 25.09.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

internal class FriendsTableViewControllerVieModel {
	var tableViewController: UITableViewController?
	
	lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
		refreshControl.tintColor = UIColor.white
		return refreshControl
	}()
	
	var users: [User] = []
	
	@objc func refresh(sender: UIRefreshControl) {
		updateUsers()
	}
	
	func updateUsers() {
		APIController.getAllUser { (success, error, users) in
			if let users = users {
				self.users = users
				self.tableViewController?.tableView.reloadData()
				self.refreshControl.endRefreshing()
			}
		}
	}
}

class FriendsTableViewController: UITableViewController {
	
	var viewModel = FriendsTableViewControllerVieModel()
	lazy var searchBar: UISearchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = "Friends"
		tableView.backgroundColor = Colors.darkGray
		tableView.estimatedRowHeight = UITableViewAutomaticDimension
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.nibAndReuseIdentifier)
		tableView.separatorStyle = .none
		tableView.addSubview(viewModel.refreshControl)
		setupSearchController()

		viewModel.tableViewController = self
		if AppDelegate.shared.friendsChache == nil {
			viewModel.updateUsers()
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FriendTableViewCell()
		let friendTableViewCellViewModel = FriendTableViewCellViewModel(user: viewModel.users[indexPath.row], cell: cell)
		cell.viewModel = friendTableViewCellViewModel
        return cell
    }
}

extension FriendsTableViewController: UISearchBarDelegate, UISearchControllerDelegate {
	
	private func setupSearchController() {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.delegate = self
		navigationItem.searchController = searchController
		searchController.searchBar.tintColor = Colors.lightGray
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		
	}
}











