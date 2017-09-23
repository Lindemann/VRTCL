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
            let index = string.index(string.startIndex, offsetBy: 1)
            string = "\(string[index...])"
		} else if string.hasPrefix("0x") {
            let index = string.index(string.startIndex, offsetBy: 2)
            string = "\(string[index...])"
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

	func lighter(by percentage:CGFloat = 30.0) -> UIColor {
		return self.adjust(by: abs(percentage)) ?? UIColor.yellow
	}

	func darker(by percentage:CGFloat = 30.0) -> UIColor {
		return self.adjust(by: -1 * abs(percentage)) ?? UIColor.yellow
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

extension UIImage {
	func resized(withPercentage percentage: CGFloat) -> UIImage? {
		let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
		UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
		defer { UIGraphicsEndImageContext() }
		draw(in: CGRect(origin: .zero, size: canvasSize))
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	func resized(toWidth width: CGFloat) -> UIImage? {
		let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
		UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
		defer { UIGraphicsEndImageContext() }
		draw(in: CGRect(origin: .zero, size: canvasSize))
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	func resized(toHeight height: CGFloat) -> UIImage? {
		let canvasSize = CGSize(width: CGFloat(ceil(height/size.height * size.width)), height: height)
		UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
		defer { UIGraphicsEndImageContext() }
		draw(in: CGRect(origin: .zero, size: canvasSize))
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	func resizeTo(max: CGFloat) -> UIImage? {
		if size.width < max || size.height < max { return self }
		if size.width > size.height {
			return resized(toHeight: max)
		} else {
			return resized(toWidth: max)
		}
	}
}
