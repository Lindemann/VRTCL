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
	
	func swapFriendToTop() {
		APIController.following { (success, error, friends) in
			if success {
				guard let friends = friends else { return }
				for friend in friends {
					for (index, user) in self.users.enumerated() {
						if friend == user {
							user.isFriend = true
							let tmp = self.users.remove(at: index)
							self.users.insert(tmp, at: 0)
							self.tableViewController?.tableView.reloadData()
						}
					}
				}
			}
			self.refreshControl.endRefreshing()
		}
	}
	
	@objc func refresh(sender: UIRefreshControl) {
		updateUsers()
	}
	
	func updateUsers() {
		APIController.getAllUsers { (success, error, users) in
			if let users = users {
				self.users = users
				self.romoveLogedInUser() // API returns all users including logged in user
				self.swapFriendToTop()
				self.tableViewController?.tableView.reloadData()
			}
		}
	}
	
	func romoveLogedInUser() {
		for (index, user) in users.enumerated() {
			if User.shared == user {
				users.remove(at: index)
			}
		}
	}
}

class FriendsTableViewController: UITableViewController {
	
	var viewModel = FriendsTableViewControllerVieModel()

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = "Find Friends"
		tableView.backgroundColor = Colors.darkGray
		tableView.estimatedRowHeight = UITableViewAutomaticDimension
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.nibAndReuseIdentifier)
		tableView.separatorStyle = .none
		tableView.addSubview(viewModel.refreshControl)
		setupSearchController()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		viewModel.tableViewController = self
		if AppDelegate.shared.friendsChache == nil {
			viewModel.updateUsers()
		}
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
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let friend = viewModel.users[indexPath.row]
		let timelineTableViewController = TimelineTableViewController()
		timelineTableViewController.friend = friend
		timelineTableViewController.mode = .friend
		navigationController?.pushViewController(timelineTableViewController, animated: true)
	}
}

extension FriendsTableViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
	
	func updateSearchResults(for searchController: UISearchController) {
	}
	
	func willDismissSearchController(_ searchController: UISearchController) {
		viewModel.updateUsers()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		APIController.search(term: searchBar.text ?? "") { (success, error, users) in
			if success {
				guard let users = users else { return }
				self.viewModel.users = users
				self.tableView.reloadData()
				self.viewModel.romoveLogedInUser()
				self.viewModel.swapFriendToTop()
				// TODO: Hot Fix...rethink later!
				self.tableView.reloadData()
			}
		}
	}

	private func setupSearchController() {
		let searchController = UISearchController(searchResultsController: nil)
		navigationItem.searchController = searchController
		searchController.obscuresBackgroundDuringPresentation = false
		definesPresentationContext = true
		searchController.searchResultsUpdater = self
		searchController.delegate = self
		searchController.searchBar.delegate = self
		searchController.searchBar.tintColor = Colors.lightGray
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
	}
}











