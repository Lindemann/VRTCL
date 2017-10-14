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
			var string = ""
			if let subLocality = placemark.subLocality {
				string = "\(placemark.locality ?? ""), \(subLocality)"
			} else {
				string = "\(placemark.locality ?? "")"
			}
			completion(string, error)
//			if let areasOfInterest = placemark.areasOfInterest?[1] {
//				print(areasOfInterest)
//			}
		})
	}
}

extension UIImage {
    // Source: https://gist.github.com/tomasbasham/10533743
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    /// Switch MIN to MAX for aspect fill instead of fit.
    ///
    /// - parameter newSize: newSize the size of the bounds the image must fit within.
    ///
    /// - returns: a new scaled image.
    func scaleImageToSize(newSize: CGSize) -> UIImage? {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth = newSize.width/size.width
        let aspectheight = newSize.height/size.height
        
        let aspectRatio = max(aspectWidth, aspectheight)
        
        scaledImageRect.size.width = size.width * aspectRatio;
        scaledImageRect.size.height = size.height * aspectRatio;
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage ?? nil
    }
}
