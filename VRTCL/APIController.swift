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
	
	#if (arch(i386) || arch(x86_64)) && os(iOS) //Simulator
		static let baseURL = "http://localhost:8080/"
	#else //Device
		static let baseURL = "https://vrtcl.herokuapp.com/"
	#endif
	
	static func login(email: String, password: String, completion: ((Bool, Error?, String?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let base64 = Data((email + ":" + password).utf8).base64EncodedString()
		let passwordHeader: HTTPHeaders = ["Authorization": "Basic \(base64)"]
		Alamofire.request(baseURL + "login", method: .post, headers: passwordHeader).validate().responseJSON { response in
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
		Alamofire.request(baseURL + "user", method: .get, headers: tokenHeader).validate().responseJSON { response in
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
				print("💥 User API: \(error)")
				completion?(false, response.error, nil)
			}
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func signup(email: String, name: String, password: String, completion: ((Bool, Error?, User?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let parameters: Parameters = ["name" : name, "email" : email, "password" : password]
		Alamofire.request(baseURL + "signup", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
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
	
	static func postSessions(completion: ((Bool, Error?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let user = AppDelegate.shared.user
		let tokenHeader: HTTPHeaders = ["Authorization": "Bearer \(user.token ?? "")"]
		Alamofire.request(baseURL + "sessions", method: .post, parameters: user.sessionsJSON, encoding: JSONEncoding.default, headers: tokenHeader).validate().responseString { response in
			if let error = response.error {
				print("💥 Post Sessions API: \(error)")
				completion?(false, response.error)
			}
			completion?(true, nil)
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	static func showAlertFor(reason: String, In viewController: UIViewController) {
		let alertController = UIAlertController(title: reason, message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "Ok", style: .default)
		alertController.addAction(action)
		viewController.present(alertController, animated: true, completion: nil)
	}
	
}
