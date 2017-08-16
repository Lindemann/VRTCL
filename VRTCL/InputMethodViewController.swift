//
//  InputMethodViewController.swift
//  VRTCL
//
//  Created by Lindemann on 04.08.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class InputMethodViewController: UIViewController {

	var viewModel = SessionViewModel()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.darkGray
		navigationItem.title = "Choose Tracking Method"
		navigationController?.navigationBar.barTintColor = viewModel.navigationBarColor
		setupButtons()
    }
	
	override func willMove(toParentViewController parent: UIViewController?) {
		super.willMove(toParentViewController: parent)
		self.navigationController?.navigationBar.barTintColor = Colors.bar
	}
	
	private func setupButtons() {
		let manualTrackingButton = FatButton(color: viewModel.navigationBarColor, title: "Manual Tracking", hasArrow: true)
		manualTrackingButton.addTarget(self, action: #selector(manualTracking), for: .touchUpInside)
		
		let iBeaconTrackingButton = FatButton(color: viewModel.navigationBarColor, title: "iBeacon Tracking", hasArrow: false)
		iBeaconTrackingButton.addTarget(self, action: #selector(iBeaconracking), for: .touchUpInside)
		
		let altimeterTrackingButton = FatButton(color: viewModel.navigationBarColor, title: "Altimeter Tracking", hasArrow: false)
		altimeterTrackingButton.addTarget(self, action: #selector(altimeterTracking), for: .touchUpInside)
		
		let stackView = UIStackView(arrangedSubviews: [manualTrackingButton, iBeaconTrackingButton, altimeterTrackingButton])
		stackView.spacing = 40
		stackView.axis = .vertical
		view.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		
	}
	
	@objc private func manualTracking() {
		let editSessionTableViewController = EditSessionViewController()
		editSessionTableViewController.viewModel.session = viewModel.session
		navigationController?.pushViewController(editSessionTableViewController, animated: true)
	}
	
	@objc private func iBeaconracking() {
		let iBeaconTableViewController = IBeaconTableViewController()
		iBeaconTableViewController.viewModel.session = viewModel.session
		let navigationController = NavigationController()
		navigationController.setViewControllers([iBeaconTableViewController], animated: false)
		present(navigationController, animated: true, completion: nil)
	}
	
	@objc private func altimeterTracking() {
		let altimeterViewController = AltimeterViewController()
		altimeterViewController.viewModel.session = viewModel.session
		let navigationController = NavigationController()
		navigationController.setViewControllers([altimeterViewController], animated: false)
		present(navigationController, animated: true, completion: nil)
	}

}
