//
//  AltitudeViewController.swift
//  VRTCL
//
//  Created by Lindemann on 15.08.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit
import CoreMotion

class AltimeterViewController: UIViewController {
	
	var viewModel = SessionViewModel()
	
	var counterLabel: UILabel!
	var altitudeLabel: UILabel!
	var altimeter = CMAltimeter()
	let routeCounter = RouteCounter()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = Colors.darkGray
		navigationItem.title = "Altimeter Tracking"
		navigationController?.navigationBar.barTintColor = viewModel.navigationBarColor
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
		navigationItem.rightBarButtonItem?.isEnabled = false
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
		
		setupAltimeterUI()
		startAltimeter()
	}
	
	// MARK: Helper
	
	@objc func save() {
		if routeCounter.routesCount > 0 {
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
			navigationController?.dismiss(animated: true, completion: nil)
		}
	}
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true, completion: nil)
	}
}

// MARK: - Altimeter
extension AltimeterViewController {
	
	private func setupAltimeterUI() {
		//Labels
		counterLabel = UILabel(frame: CGRect.zero)
		counterLabel.text = "\(routeCounter.routesCount)"
		counterLabel.textColor = UIColor.white
		counterLabel.textAlignment = .center
		counterLabel.font = UIFont.systemFont(ofSize: 160, weight: .medium)
		counterLabel.translatesAutoresizingMaskIntoConstraints = false
		counterLabel.heightAnchor.constraint(equalToConstant: 130).isActive = true // Makes it smaller
		
		let routesLabel = UILabel(frame: CGRect.zero)
		routesLabel.text = "Routes"
		routesLabel.textColor = UIColor.white
		routesLabel.textAlignment = .center
		routesLabel.font = UIFont.systemFont(ofSize: 40, weight: .thin)
		
		altitudeLabel = UILabel(frame: CGRect.zero)
		altitudeLabel.text = "0.0 m"
		altitudeLabel.textColor = UIColor.white
		altitudeLabel.textAlignment = .center
		altitudeLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium)
		altitudeLabel.translatesAutoresizingMaskIntoConstraints = false
		altitudeLabel.heightAnchor.constraint(equalToConstant: 90).isActive = true // Makes it smaller
		
		let altitudeTextLabel = UILabel(frame: CGRect.zero)
		altitudeTextLabel.text = "Altitude"
		altitudeTextLabel.textColor = UIColor.white
		altitudeTextLabel.textAlignment = .center
		altitudeTextLabel.font = UIFont.systemFont(ofSize: 40, weight: .thin)
		
		// Button
		let resetButton = TagButton(text: "Reset Ground Level", interactionMode: .highlightable)
		resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
		// Workaround for dumb problem where stackview has the width of resetButton when added directly
		let workaroundButtonView = UIView()
		workaroundButtonView.translatesAutoresizingMaskIntoConstraints = false
		workaroundButtonView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
		workaroundButtonView.heightAnchor.constraint(equalToConstant: resetButton.frame.height).isActive = true
		workaroundButtonView.addSubview(resetButton)
		resetButton.translatesAutoresizingMaskIntoConstraints = false
		resetButton.centerXAnchor.constraint(equalTo: workaroundButtonView.centerXAnchor).isActive = true
		resetButton.centerYAnchor.constraint(equalTo: workaroundButtonView.centerYAnchor).isActive = true
		
		// StackViews
		let counterStackView = UIStackView(arrangedSubviews: [counterLabel, routesLabel])
		counterStackView.spacing = 20
		counterStackView.axis = .vertical
		
		let altitudeStackView = UIStackView(arrangedSubviews: [altitudeLabel, altitudeTextLabel, workaroundButtonView])
		altitudeStackView.spacing = 20
		altitudeStackView.axis = .vertical
		
		let containerStackView = UIStackView(arrangedSubviews: [counterStackView, altitudeStackView])
		containerStackView.spacing = 80
		containerStackView.axis = .vertical
		view.addSubview(containerStackView)
		containerStackView.translatesAutoresizingMaskIntoConstraints = false
		containerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		containerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}
	
	func startAltimeter() {
		print("Started relative altitude updates.")
		// Check if altimeter feature is available
		if (CMAltimeter.isRelativeAltitudeAvailable()) {
			// Start altimeter updates, add it to the main queue
			altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { [weak self] (altitudeData:CMAltitudeData?, error:Error?) in
				if (error != nil) {
					// If there's an error, stop updating and alert the user
					self?.reset()
				} else {
					// Relative altitude in meters
					let altitude = altitudeData!.relativeAltitude.doubleValue
					self?.altitudeLabel.text = String(format: "%.01f m", altitude)
					
					self?.routeCounter.monitor(altitude: altitude)
					self?.counterLabel.text = "\(self?.routeCounter.routesCount ?? 0)"
				}
			})
		} else {
			print("Altimeter not available")
		}
	}
	
	@objc func reset() {
		altitudeLabel.text = "0.0 m"
		altimeter.stopRelativeAltitudeUpdates()
		print("Stopped relative altitude updates.")
//		routeCounter.hasReachedThreshold = false
//		routeCounter.routesCount = 0
		altimeter = CMAltimeter()
		startAltimeter()
	}
}

internal class RouteCounter {
	
	let threshold = 0.4
	var routesCount = 0
	var hasReachedThreshold = false
	let relativeGroundRange = -100 ... 0.3
	
	func monitor(altitude: Double) {
		if altitude > threshold {
			hasReachedThreshold = true
		}
		if relativeGroundRange ~= altitude && hasReachedThreshold {
			routesCount += 1
			hasReachedThreshold = false
		}
	}
}

