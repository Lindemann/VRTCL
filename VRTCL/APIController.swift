//
//  APIController.swift
//  VRTCL
//
//  Created by Lindemann on 18.09.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import Foundation
import Alamofire

struct APIController {
	
	static let localhostURL = "http://localhost:8080/"
	static let herokuURL = ""
	
	static func login(email: String, password: String, completion: ((Bool, Error?, String?) -> Void)?) {
		let base64 = Data((email + ":" + password).utf8).base64EncodedString()
		let passwordHeader: HTTPHeaders = ["Authorization": "Basic \(base64)"]
		Alamofire.request(localhostURL + "login", method: .post, headers: passwordHeader).validate().responseJSON { response in
			if let dictionary = response.result.value as? [String: Any] {
				if let token = dictionary["token"] as? String {
					print("token: \(token)")
					completion?(true, response.error, token)
				}
			}
		}
	}
	
	static func user(token: String,  completion: ((Bool, Error?, String?) -> Void)?) {
		let tokenHeader: HTTPHeaders = ["Authorization": "Bearer \(token)"]
		Alamofire.request(localhostURL + "user", method: .get, headers: tokenHeader).validate().responseJSON { response in
			if let dictionary = response.result.value as? [String: Any] {
				if let name = dictionary["name"] as? String {
					print("name: \(name)")
					completion?(true, response.error, name)
				}
			}
		}
	}
}
