//
//  Extensions.swift
//  VRTCL
//
//  Created by Lindemann on 28.04.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension UIColor {
	
	convenience init(hex: String?) {
		var string = hex ?? "#FF5778"
		if string.hasPrefix("#") {
			string = string.substring(from: string.index(string.startIndex, offsetBy: 1))
		} else if string.hasPrefix("0x") {
			string = string.substring(from: string.index(string.startIndex, offsetBy: 2))
		}
		let scanner = Scanner(string: string)
		scanner.scanLocation = 0
		var rgbValue: UInt64 = 0
		scanner.scanHexInt64(&rgbValue)
		let r = (rgbValue & 0xff0000) >> 16
		let g = (rgbValue & 0xff00) >> 8
		let b = rgbValue & 0xff
		self.init(red: CGFloat(r) / 0xff, green: CGFloat(g) / 0xff, blue: CGFloat(b) / 0xff, alpha: 1
		)
	}
	
	var toHexString: String {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		self.getRed(&r, green: &g, blue: &b, alpha: &a)
		return String(format: "%02X%02X%02X", Int(r * 0xff), Int(g * 0xff), Int(b * 0xff)
		)
	}

	func lighter(by percentage:CGFloat = 30.0) -> UIColor? {
		return self.adjust(by: abs(percentage))
	}

	func darker(by percentage:CGFloat = 30.0) -> UIColor? {
		return self.adjust(by: -1 * abs(percentage))
	}

	private func adjust(by percentage:CGFloat=30.0) -> UIColor? {
		var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
		if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
			return UIColor(red: min(r + percentage/100, 1.0), green: min(g + percentage/100, 1.0), blue: min(b + percentage/100, 1.0), alpha: a)
		} else {
			return nil
		}
	}
}

extension CLLocation {
	func nameRequest(completion: @escaping (String?, Error?) -> Void ) {
		let geoCoder = CLGeocoder()
		geoCoder.reverseGeocodeLocation(self, completionHandler: { placemarks, error in
			guard let placemark = placemarks?[0] else {
				completion(nil, error)
				return
			}
			let string = "\(placemark.locality ?? ""), \(placemark.subLocality ?? "")"
			completion(string, error)
//			if let areasOfInterest = placemark.areasOfInterest?[1] {
//				print(areasOfInterest)
//			}
		})
	}
}

// Find view controller retain cycles
// Source: http://holko.pl/2017/06/26/checking-uiviewcontroller-deallocation/?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=email&utm_source=iOS_Dev_Weekly_Issue_307
extension UIViewController {
	public func dch_checkDeallocation(afterDelay delay: TimeInterval = 2.0) {
		let rootParentViewController = dch_rootParentViewController
		
		// We don’t check `isBeingDismissed` simply on this view controller because it’s common
		// to wrap a view controller in another view controller (e.g. in UINavigationController)
		// and present the wrapping view controller instead.
		if isMovingFromParentViewController || rootParentViewController.isBeingDismissed {
			let viewControllerType = type(of: self)
			let disappearanceSource: String = isMovingFromParentViewController ? "removed from its parent" : "dismissed"
			
			DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [weak self] in
				assert(self == nil, "\(viewControllerType) not deallocated after being \(disappearanceSource)")
			})
		}
	}
	
	private var dch_rootParentViewController: UIViewController {
		var root = self
		
		while let parent = root.parent {
			root = parent
		}
		return root
	}
}
