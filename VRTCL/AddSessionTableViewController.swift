//
//  SessionsTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 09.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

// MARK: - View model
internal struct SessionsTableViewControllerViewModel {
	
	var hasActiveBoulderingSession: Bool {
		return AppDelegate.shared.boulderingSession != nil
	}
	
	var hasActivesportClimbingSession: Bool {
		return AppDelegate.shared.sportClimbingSession != nil
	}
}

// MARK: - Controller
class AddSessionTableViewController: UITableViewController {
	
	var viewModel = SessionsTableViewControllerViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.rowHeight = 100
		tableView.bounces = false
		tableView.backgroundColor = Colors.darkGray
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}
	
    // MARK: Table view data source

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
}

// MARK: - Cells
extension AddSessionTableViewController: SessionsButtonTableviewCellDelegate {
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
		cell.kind = .bouldering
		cell.delegate = self
		cell.button?.hasArrow = viewModel.hasActiveBoulderingSession
		return cell
	}
	
	var sportClimbingButtonCell: SessionsButtonTableviewCell {
		let cell = SessionsButtonTableviewCell()
		cell.kind = .sportClimbing
		cell.delegate = self
		cell.button?.hasArrow = viewModel.hasActivesportClimbingSession
		return cell
	}
	
	// MARK: SessionsButtonTableviewCellDelegate
	
	@objc func sportClimbingButtonWasPressed() {
		if !viewModel.hasActivesportClimbingSession {
			AppDelegate.shared.sportClimbingSession = Session(kind: .sportClimbing)
			tableView.reloadData()
		}
		
		guard let sportClimbingSession =  AppDelegate.shared.sportClimbingSession else { return }
		pushViewControllerWith(session: sportClimbingSession)
		
		if AppDelegate.shared.sportClimbingSession?.date == nil {
			AppDelegate.shared.sportClimbingSession?.date = Date()
		}
	}
	
	@objc func boulderingButtonWasPressed() {
		if !viewModel.hasActiveBoulderingSession {
			AppDelegate.shared.boulderingSession = Session(kind: .bouldering)
			tableView.reloadData()
		}
		
		guard let boulderingSession =  AppDelegate.shared.boulderingSession else { return }
		pushViewControllerWith(session: boulderingSession)
		
		if AppDelegate.shared.boulderingSession?.date == nil {
			AppDelegate.shared.boulderingSession?.date = Date()
		}
	}
	
	private func pushViewControllerWith(session: Session) {
		let editSessionTableViewController = EditSessionViewController()
		editSessionTableViewController.viewModel.session = session
		navigationController?.pushViewController(editSessionTableViewController, animated: true)
	}
}

// MARK: Cell classes
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

@objc protocol SessionsButtonTableviewCellDelegate: class {
	@objc func sportClimbingButtonWasPressed()
	@objc func boulderingButtonWasPressed()
}

class SessionsButtonTableviewCell: UITableViewCell {
	
	static let nibNameAndReuseIdentifier = String(describing: SessionsButtonTableviewCell.self)
	
	weak var delegate: SessionsButtonTableviewCellDelegate?
	
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
	
	var kind: Kind? {
		didSet {
			guard let kind = self.kind else { return }
			switch kind {
			case .sportClimbing:
				button = FatButton(origin: CGPoint.zero, color: Colors.purple, title: "Sport Climbing")
				button?.addTarget(delegate, action: #selector(delegate?.sportClimbingButtonWasPressed), for: .touchUpInside)
			case .bouldering:
				button = FatButton(origin: CGPoint.zero, color: Colors.discoBlue, title: "Bouldering")
				button?.addTarget(delegate, action: #selector(delegate?.boulderingButtonWasPressed), for: .touchUpInside)
			}
		}
	}
}
