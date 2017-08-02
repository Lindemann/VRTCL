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
	var user = User.shared
	static let shared = UIApplication.shared.delegate as! AppDelegate
	
	var boulderingSession: Session?
	var sportClimbingSession: Session?
	
	let sportClimbingSessionLocationManager = CLLocationManager()
	let bouleringSessionLocationManager = CLLocationManager()
	var sportClimbingInitialLocation: CLLocation? {
		didSet {
			guard let sportClimbingInitialLocation = sportClimbingInitialLocation else { return }
			initialLocationDelegate?.initialLocationWasSet(initialLocation: sportClimbingInitialLocation)
		}
	}
	var boulderingInitialLocation: CLLocation? {
		didSet {
			guard let boulderingInitialLocation = boulderingInitialLocation else { return }
			initialLocationDelegate?.initialLocationWasSet(initialLocation: boulderingInitialLocation)
		}
	}
	
	weak var initialLocationDelegate: InitialLocationDelegate?

	func applicationDidFinishLaunching(_ application: UIApplication) {
		// Restore sessions from JSON cache
		user.sessions = JsonIO.codableType([Session].self) ?? []
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
	func userHasLeftInitialLocation()
}

// MARK:  - Handle location stuff
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
	
	private func distance(from: CLLocation?, to: CLLocation?, isBiggerThan meters: Double) -> Bool {
		guard let from = from, let to = to else { return false }
		let distanceInMeters = to.distance(from: from)
		if distanceInMeters > meters {
			return true
		} else {
			return false
		}
	}
	
	 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let maxDistance: Double = 500
		if sportClimbingInitialLocation == nil && manager === sportClimbingSessionLocationManager {
			sportClimbingInitialLocation = locations[0]
		}
		if distance(from: sportClimbingInitialLocation, to: locations.last, isBiggerThan: maxDistance) {
			initialLocationDelegate?.userHasLeftInitialLocation()
			sportClimbingSessionLocationManager.stopUpdatingLocation()
		}
		
		if boulderingInitialLocation == nil && manager === bouleringSessionLocationManager {
			boulderingInitialLocation = locations[0]
		}
		if distance(from: boulderingInitialLocation, to: locations.last, isBiggerThan: maxDistance) {
			initialLocationDelegate?.userHasLeftInitialLocation()
			bouleringSessionLocationManager.stopUpdatingLocation()
		}
	}
}
