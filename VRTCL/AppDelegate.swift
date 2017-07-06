//
//  AppDelegate.swift
//  VRTCL
//
//  Created by Lindemann on 11/05/15.
//  Copyright (c) 2015 Lindemann. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var user = User()
	static let shared = UIApplication.shared.delegate as! AppDelegate
	
	let sportClimbingSessionLocationManager = CLLocationManager()
	let bouleringSessionLocationManager = CLLocationManager()
	var sportClimbingLocation: CLLocation? {
		didSet {
			guard let sportClimbingLocation = sportClimbingLocation else { return }
			initialLocationDelegate?.initialLocationWasSet(initialLocation: sportClimbingLocation)
		}
	}
	var boulderingLocation: CLLocation? {
		didSet {
			guard let boulderingLocation = boulderingLocation else { return }
			initialLocationDelegate?.initialLocationWasSet(initialLocation: boulderingLocation)
		}
	}
	
	weak var initialLocationDelegate: InitialLocationDelegate?

	func applicationDidFinishLaunching(_ application: UIApplication) {
		setupLocationTracking()
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
}

protocol InitialLocationDelegate: class {
	func initialLocationWasSet(initialLocation: CLLocation)
}

extension AppDelegate: CLLocationManagerDelegate {
	
	private func setupLocationTracking() {
		sportClimbingSessionLocationManager.delegate = self
		sportClimbingSessionLocationManager.desiredAccuracy = kCLLocationAccuracyBest
		sportClimbingSessionLocationManager.requestWhenInUseAuthorization()
		sportClimbingSessionLocationManager.allowsBackgroundLocationUpdates = true
		
		bouleringSessionLocationManager.delegate = self
		bouleringSessionLocationManager.desiredAccuracy = kCLLocationAccuracyBest
		bouleringSessionLocationManager.requestWhenInUseAuthorization()
		bouleringSessionLocationManager.allowsBackgroundLocationUpdates = true
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if sportClimbingLocation == nil && manager === sportClimbingSessionLocationManager {
			sportClimbingLocation = locations[0]
		}
		if boulderingLocation == nil && manager === bouleringSessionLocationManager {
			boulderingLocation = locations[0]
		}
	}
}
