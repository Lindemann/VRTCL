//
//  ViewController.swift
//  AltiRoute
//
//  Created by Lindemann on 16/12/2016.
//  Copyright © 2016 Lindemann. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var routesCount: UILabel!
    @IBOutlet weak var altLabel: UILabel!
    
    var altimeter = CMAltimeter()
    let routeCounter = RouteCounter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAltimeter()
        //setupUI()
    }
    
    func setupUI() {
        // Setup Colors
        let gray = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.00)
        navigationController?.navigationBar.barTintColor = UIColor(red:0.80, green:0.99, blue:0.29, alpha:1.00)
        view.backgroundColor = gray
        navigationController?.navigationBar.tintColor = gray
    }
    
    func startAltimeter() {
        print("Started relative altitude updates.")
        // Check if altimeter feature is available
        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            // Start altimeter updates, add it to the main queue
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (altitudeData:CMAltitudeData?, error:Error?) in
                if (error != nil) {
                    // If there's an error, stop updating and alert the user
                    self.reset()
                } else {
                    // Relative altitude in meters
                    let altitude = altitudeData!.relativeAltitude.doubleValue
                    self.altLabel.text = String(format: "%.01f m", altitude)
                    
                    self.routeCounter.monitor(altitude: altitude)
                    self.routesCount.text = "\(self.routeCounter.routesCount)"
                }
            })
        } else {
            print("Altimeter not available")
        }
    }
    
    @IBAction func reset() {
        altLabel.text = "0.0 m"
        altimeter.stopRelativeAltitudeUpdates()
        print("Stopped relative altitude updates.")
        routeCounter.hasReachedThreshold = false
        routeCounter.routesCount = 0
        altimeter = CMAltimeter()
        startAltimeter()
    }
    
}

class RouteCounter {
    
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
