//
//  IBeaconTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 03.08.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - View model
struct IBeaconTableViewControllerViewModell {
	
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
	
	var hasStartedClimb = false
	var hasTopedClimb = false
	
	internal var estimatedDuration: Int {
		guard let date = session.date else { return 0 }
		return Calendar.current.dateComponents([.hour], from: date, to: Date()).hour ?? 0
	}
	
	internal func setSessionToNil() {
		switch kind {
		case .bouldering:
			AppDelegate.shared.boulderingSession = nil
		case .sportClimbing:
			AppDelegate.shared.sportClimbingSession = nil
		}
	}
}

// MARK: - Controller
class IBeaconTableViewController: UITableViewController {
	
	var viewModel = IBeaconTableViewControllerViewModell()
	
	var locationManager = CLLocationManager()
	let proximityUUID = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")
	let majorID: CLBeaconMajorValue = 0
	let beaconID = "beacon"
	var region: CLBeaconRegion { return CLBeaconRegion(proximityUUID: proximityUUID!, major: majorID, identifier: beaconID) }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.backgroundColor = Colors.darkGray
		tableView.separatorStyle = .none
		let sumOfAllBarHeights: CGFloat = 113
		tableView.rowHeight = (view.frame.height - sumOfAllBarHeights) / 2
		tableView.bounces = false
		tableView.allowsSelection = false
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
//		navigationItem.rightBarButtonItem?.isEnabled = false
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
		navigationItem.title = viewModel.navigationBarTitle
		navigationController?.navigationBar.barTintColor = viewModel.navigationBarColor
		
		setupIBeaconStuff()
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
		let grade = viewModel.kind == .sportClimbing ? GradeScales.gradeScaleFor(system: .uiaa)[7] : GradeScales.gradeScaleFor(system: .font)[7]
		let climb = Climb(style: .redpoint, grade: grade, index: 0)
		viewModel.session.climbs?.append(climb)
		viewModel.session.duration = viewModel.estimatedDuration
		viewModel.session.mood = .good
		viewModel.session.location = Location(venue: .gym, name: "Berlin", coordinate: nil)
		
		AppDelegate.shared.user.sessions.insert(viewModel.session, at: 0)
		// Store sessions to JSON cache
		if AppDelegate.shared.user.sessions.count > 0 {
			JsonIO.save(codable: AppDelegate.shared.user.sessions)
		}
		viewModel.setSessionToNil()
		
		locationManager.stopUpdatingLocation()

		navigationController?.dismiss(animated: true, completion: {
			self.navigationController?.navigationController?.popToRootViewController(animated: true)
		})
	}
	
	@objc func cancel() {
		viewModel.setSessionToNil()
		locationManager.stopUpdatingLocation()
		navigationController?.dismiss(animated: true, completion: nil)
	}
}

// MARK: - iBeacon
extension IBeaconTableViewController: CLLocationManagerDelegate {
	
	func setupIBeaconStuff() {
		locationManager.delegate = self
		if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
			locationManager.startMonitoring(for: region)
			locationManager.startRangingBeacons(in: region)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
		if region is CLBeaconRegion {
			if CLLocationManager.isRangingAvailable() {
				manager.startRangingBeacons(in: region as! CLBeaconRegion)
			}
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
		if beacons.count > 0 {
			for beacon in beacons {
				let minor = CLBeaconMinorValue(truncating: beacon.minor)
				func rangedIBeacon() {
					tableView.reloadData()
					if viewModel.hasStartedClimb && viewModel.hasTopedClimb {
						manager.stopRangingBeacons(in: region)
						navigationItem.rightBarButtonItem?.isEnabled = true
					}
				}
				
//				if beacon.proximity == .near {
//					print("near \(minor), accuracy \(beacon.accuracy)")
//				}
//				if beacon.proximity == .immediate {
//					print("immediate \(minor), accuracy \(beacon.accuracy)")
//				}
				// Start
				if minor == 0  && ( beacon.proximity == .immediate || beacon.proximity == .near ) {
					viewModel.hasStartedClimb = true
					rangedIBeacon()
				}
				// Top
				if minor == 1 && beacon.proximity == .immediate && viewModel.hasStartedClimb {
					viewModel.hasTopedClimb = true
					rangedIBeacon()
				}
			}
		}
	}
}

// MARK: - Cells
extension IBeaconTableViewControllerViewModell {
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

extension IBeaconTableViewController {
	
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
