//
//  SessionsTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 09.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

struct SessionsTableViewControllerViewModel {
	var boulderSession: Session?
	var sportClimbingSession: Session?
	
	var hasActiveBoulderingSession: Bool {
		return boulderSession != nil
	}
	
	var hasActivesportClimbingSession: Bool {
		return sportClimbingSession != nil
	}
}

class AddSessionTableViewController: UITableViewController, SessionsButtonTableviewCellDelegate {
	
	var viewModel = SessionsTableViewControllerViewModel()
	
	// Cells
	var startSessionCell: SessionsHeadingTableviewCell {
		let cell = SessionsHeadingTableviewCell()
		cell.mode = .startSession
		return cell
	}
	
	var activeSessionCell: SessionsHeadingTableviewCell {
		let cell = SessionsHeadingTableviewCell()
		cell.mode = .activeSession
		return cell
	}
	
	var boulderingButtonCell: SessionsButtonTableviewCell {
		let cell = SessionsButtonTableviewCell()
		cell.mode = .bouldering
		cell.delegate = self
		cell.button?.hasArrow = viewModel.hasActiveBoulderingSession
		return cell
	}
	
	var sportClimbingButtonCell: SessionsButtonTableviewCell {
		let cell = SessionsButtonTableviewCell()
		cell.mode = .sportClimbing
		cell.delegate = self
		cell.button?.hasArrow = viewModel.hasActivesportClimbingSession
		return cell
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.rowHeight = 100
		tableView.bounces = false
		tableView.backgroundColor = Colors.darkGray
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
    }
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (viewModel.hasActiveBoulderingSession && viewModel.hasActivesportClimbingSession) ||
		 (!viewModel.hasActiveBoulderingSession && !viewModel.hasActivesportClimbingSession) {
			return 3
		} else {
			return 4
		}
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if !viewModel.hasActiveBoulderingSession && !viewModel.hasActivesportClimbingSession {
			switch indexPath.row {
			case 0:
				return startSessionCell
			case 1:
				return boulderingButtonCell
			case 2:
				return sportClimbingButtonCell
			default:
				return UITableViewCell()
			}
		}
		
		if viewModel.hasActiveBoulderingSession && viewModel.hasActivesportClimbingSession {
			switch indexPath.row {
			case 0:
				return activeSessionCell
			case 1:
				return boulderingButtonCell
			case 2:
				return sportClimbingButtonCell
			default:
				return UITableViewCell()
			}
		}
		
		if viewModel.hasActiveBoulderingSession && !viewModel.hasActivesportClimbingSession {
			switch indexPath.row {
			case 0:
				return startSessionCell
			case 1:
				return sportClimbingButtonCell
			case 2:
				return activeSessionCell
			case 3:
				return boulderingButtonCell
			default:
				return UITableViewCell()
			}
		}
		
		if !viewModel.hasActiveBoulderingSession && viewModel.hasActivesportClimbingSession {
			switch indexPath.row {
			case 0:
				return startSessionCell
			case 1:
				return boulderingButtonCell
			case 2:
				return activeSessionCell
			case 3:
				return sportClimbingButtonCell
			default:
				return UITableViewCell()
			}
		}

        return UITableViewCell()
    }
	
	// MARK: - SessionsButtonTableviewCellDelegate
	
	@objc func sportClimbingButtonWasPressed() {
		if !viewModel.hasActivesportClimbingSession {
			viewModel.sportClimbingSession = Session(kind: .sportClimbing)
			tableView.reloadData()
		}
		let editSessionTableViewController = EditSessionViewController()
		editSessionTableViewController.viewModel.session = viewModel.sportClimbingSession
		navigationController?.pushViewController(editSessionTableViewController, animated: true)
	}
	
	@objc func boulderingButtonWasPressed() {
		if !viewModel.hasActiveBoulderingSession {
			viewModel.boulderSession = Session(kind: .bouldering)
			tableView.reloadData()
		}
		let editSessionTableViewController = EditSessionViewController()
		editSessionTableViewController.viewModel.session = viewModel.boulderSession
		navigationController?.pushViewController(editSessionTableViewController, animated: true)
	}
	
}

class SessionsHeadingTableviewCell: UITableViewCell {
	
	static let nibNameAndReuseIdentifier = String(describing: SessionsHeadingTableviewCell.self)
	
	enum Mode {
		case startSession, activeSession
	}
	
	var mode: Mode? {
		didSet {
			guard let mode = self.mode else { return }
			textLabel?.textAlignment = .center
			textLabel?.font = Fonts.h1
			textLabel?.textColor = UIColor.white
			
			backgroundColor = UIColor.clear
			
			switch mode {
			case .activeSession:
				textLabel?.text = "Active Sessions"
			case .startSession:
				textLabel?.text = "Start Session"
			}
		}
	}
}

@objc protocol SessionsButtonTableviewCellDelegate {
	@objc func sportClimbingButtonWasPressed()
	@objc func boulderingButtonWasPressed()
}

class SessionsButtonTableviewCell: UITableViewCell {
	
	static let nibNameAndReuseIdentifier = String(describing: SessionsButtonTableviewCell.self)
	
	var delegate: SessionsButtonTableviewCellDelegate?
	
	enum Mode {
		case sportClimbing, bouldering
	}
	
	var button: FatButton? {
		didSet {
			guard let button = self.button else { return }
			addSubview(button)
			button.translatesAutoresizingMaskIntoConstraints = false
			button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
			
			backgroundColor = UIColor.clear
		}
	}
	
	var mode: Mode? {
		didSet {
			guard let mode = self.mode else { return }
			switch mode {
			case .sportClimbing:
				button = FatButton(origin: CGPoint.zero, color: Colors.purple, title: "Sport Climbing")
				button?.addTarget(delegate, action: #selector(delegate?.sportClimbingButtonWasPressed), for: .touchUpInside)
			case .bouldering:
				button = FatButton(origin: CGPoint.zero, color: Colors.skyBlue, title: "Bouldering")
				button?.addTarget(delegate, action: #selector(delegate?.boulderingButtonWasPressed), for: .touchUpInside)
			}
		}
	}
}
