//
//  iBeaconTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 03.08.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

// MARK: - View model
struct iBeaconTableViewControllerViewModell {
	
	var session: Session = Session(kind: .sportClimbing)
	var climb: Climb = Climb()
	var kind: Kind { return session.kind }
	
	internal var navigationBarColor: UIColor {
		return kind == .sportClimbing ? Colors.purple : Colors.discoBlue
	}
	
	internal var navigationBarTitle: String {
		switch kind {
		case .sportClimbing:
			return "Track Route"
		case .bouldering:
			return "Track Boulder"
		}
	}
	
	var hasStartedClimb = true
	var hasTopedClimb = false
}

// MARK: - Controller
class iBeaconTableViewController: UITableViewController {
	
	var viewModel = iBeaconTableViewControllerViewModell()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.backgroundColor = Colors.darkGray
		tableView.separatorStyle = .none
		let sumOfAllBarHeights: CGFloat = 113
		tableView.rowHeight = (view.frame.height - sumOfAllBarHeights) / 2
		tableView.bounces = false
		tableView.allowsSelection = false
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
		navigationItem.rightBarButtonItem?.isEnabled = false
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
		navigationItem.title = viewModel.navigationBarTitle
		navigationController?.navigationBar.barTintColor = viewModel.navigationBarColor
	}
	
	
	// MARK: - Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			return topTableViewCell
		case 1:
			return startTableViewCell
		default:
			return UITableViewCell()
		}
	}
	
	// MARK: Helper
	
	@objc func save() {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func cancel() {
		dismiss(animated: true, completion: nil)
	}
}

// MARK: - Cells

extension iBeaconTableViewControllerViewModell {
	var startColor: UIColor {
		return hasStartedClimb ? Colors.mint : Colors.lightGray
	}
	
	var topColor: UIColor {
		return hasTopedClimb ? Colors.mint : Colors.lightGray
	}
	
	var startText: String {
		return hasStartedClimb ? "Start ✓" : "Start"
	}
	
	var topText: String {
		return hasTopedClimb ? "Top ✓" : "Top"
	}
}

class iBeaconTableViewCell: UITableViewCell {

	var label: UILabel!
	var beaconImageView: UIImageView!
	
	init() {
		super.init(style: .default, reuseIdentifier: SessionsTableViewCell.nibAndReuseIdentifier)
		backgroundColor = UIColor.clear
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
		label.textAlignment = .center
		label.font = Fonts.h1
		
		beaconImageView = UIImageView(image: #imageLiteral(resourceName: "beacon"))
		
		let stackView = UIStackView(arrangedSubviews: [label, beaconImageView])
		stackView.spacing = 20
		stackView.axis = .vertical
		addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}
}

extension iBeaconTableViewController {
	
	private var startTableViewCell: iBeaconTableViewCell {
		let cell = iBeaconTableViewCell()
		cell.label.text = viewModel.startText
		cell.beaconImageView.tintColor = viewModel.startColor
		cell.label.textColor = viewModel.startColor
		return cell
	}
	
	private var topTableViewCell: iBeaconTableViewCell {
		let cell = iBeaconTableViewCell()
		cell.label.text = viewModel.topText
		cell.beaconImageView.tintColor = viewModel.topColor
		cell.label.textColor = viewModel.topColor
		return cell
	}
}
