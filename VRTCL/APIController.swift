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
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let base64 = Data((email + ":" + password).utf8).base64EncodedString()
		let passwordHeader: HTTPHeaders = ["Authorization": "Basic \(base64)"]
		Alamofire.request(localhostURL + "login", method: .post, headers: passwordHeader).validate().responseJSON { response in
			if let dictionary = response.result.value as? [String: Any] {
				if let token = dictionary["token"] as? String {
					print("token: \(token)")
					completion?(true, nil, token)
				}
			}
			if let error = response.error {
				print("💥 Login API: \(error)")
				completion?(false, response.error, nil)
			}
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func user(token: String,  completion: ((Bool, Error?, User?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let tokenHeader: HTTPHeaders = ["Authorization": "Bearer \(token)"]
		Alamofire.request(localhostURL + "user", method: .get, headers: tokenHeader).validate().responseJSON { response in
			if let dictionary = response.result.value as? [String: Any] {
				let user = User()
				if let name = dictionary["name"] as? String {
					user.name = name
					print("name: \(name)")
					completion?(true, nil, user)
				}
			}
			if let error = response.error {
				print("💥 User API: \(error)")
				completion?(false, response.error, nil)
			}
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func signup(email: String, name: String, password: String, completion: ((Bool, Error?, User?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let parameters: Parameters = ["name" : name, "email" : email, "password" : password]
		Alamofire.request(localhostURL + "signup", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { (response) in
			if let dictionary = response.result.value as? [String: Any] {
				let user = User()
				if let name = dictionary["name"] as? String {
					user.name = name
					print("name: \(name)")
				}
				if let email = dictionary["email"] as? String {
					user.email = email
					print("email: \(email)")
				}
				completion?(true, nil, user)
			}
			if let error = response.error {
				print("💥 Signup API: \(error)")
				completion?(false, response.error, nil)
			}
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
}
