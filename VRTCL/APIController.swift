//
//  APIController.swift
//  VRTCL
//
//  Created by Lindemann on 18.09.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import Foundation
import Alamofire

struct APIError {
	var error: Error?
	var statusCode: Int?
}

struct APIController {
	
	#if (arch(i386) || arch(x86_64)) && os(iOS) //Simulator
		static let baseURL = "http://localhost:8080/"
	#else //Device
		static let baseURL = "https://vrtcl.herokuapp.com/"
	#endif
	
	static func login(email: String, password: String, completion: ((Bool, APIError?, String?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let base64 = Data((email + ":" + password).utf8).base64EncodedString()
		let passwordHeader: HTTPHeaders = ["Authorization": "Basic \(base64)"]
		Alamofire.request(baseURL + "login", method: .post, headers: passwordHeader).validate().responseJSON { response in
			if let dictionary = response.result.value as? [String: Any] {
				if let token = dictionary["token"] as? String {
					completion?(true, nil, token)
				}
			}
			if let error = response.error {
				print("💥 Login API: \(error)")
				completion?(false, APIError(error: error, statusCode: response.response?.statusCode), nil)
			}
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func user(token: String,  completion: ((Bool, APIError?, User?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let tokenHeader: HTTPHeaders = ["Authorization": "Bearer \(token)"]
		Alamofire.request(baseURL + "user", method: .get, headers: tokenHeader).validate().responseJSON { response in
			if let dictionary = response.result.value as? [String: Any] {
				let user = parse(userDictionary: dictionary)
				completion?(true, nil, user)
			}
			if let error = response.error {
				print("💥 User API: \(error)")
				completion?(false, APIError(error: error, statusCode: response.response?.statusCode), nil)
			}
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func signup(email: String, name: String, password: String, completion: ((Bool, APIError?, User?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let parameters: Parameters = ["name" : name, "email" : email, "password" : password]
		Alamofire.request(baseURL + "signup", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
			if let dictionary = response.result.value as? [String: Any] {
				let user = parse(userDictionary: dictionary)
				completion?(true, nil, user)
			}
			if let error = response.error {
				print("💥 Signup API: \(error)")
				completion?(false, APIError(error: error, statusCode: response.response?.statusCode), nil)
			}
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func postSessions(completion: ((Bool, APIError?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let user = AppDelegate.shared.user
		let tokenHeader: HTTPHeaders = ["Authorization": "Bearer \(user.token ?? "")"]
		Alamofire.request(baseURL + "sessions", method: .post, parameters: user.sessionsJSON, encoding: JSONEncoding.default, headers: tokenHeader).validate().responseString { response in
			if let error = response.error {
				print("💥 .POST Sessions API: \(error)")
				completion?(false, APIError(error: error, statusCode: response.response?.statusCode))
			}
			completion?(true, nil)
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func getSessions(completion: ((Bool, APIError?, [Session]?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let user = AppDelegate.shared.user
		let tokenHeader: HTTPHeaders = ["Authorization": "Bearer \(user.token ?? "")"]
		Alamofire.request(baseURL + "user", method: .get, headers: tokenHeader).validate().responseJSON{ response in
			if let dictionary = response.result.value as? [String: Any] {
				if let sessionsArray = dictionary["sessions"] as? [Any] {
					completion?(true, nil, decode(sessionsArray: sessionsArray))
				}
			}
			if let error = response.error {
				print("💥 .GET Sessions API: \(error)")
				completion?(false, APIError(error: error, statusCode: response.response?.statusCode), nil)
			}
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func post(photoURL: String, completion: ((Bool, APIError?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let user = AppDelegate.shared.user
		let tokenHeader: HTTPHeaders = ["Authorization": "Bearer \(user.token ?? "")"]
		let parameters: Parameters = ["photoURL" : photoURL]
		Alamofire.request(baseURL + "photoURL", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: tokenHeader).validate().responseString { response in
			if let error = response.error {
				print("💥 .POST pohotoURL API: \(error)")
				completion?(false, APIError(error: error, statusCode: response.response?.statusCode))
			}
			completion?(true, nil)
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func getAllUser(completion: ((Bool, APIError?, [User]?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let user = AppDelegate.shared.user
		let tokenHeader: HTTPHeaders = ["Authorization": "Bearer \(user.token ?? "")"]
		Alamofire.request(baseURL + "allUser", method: .get, headers: tokenHeader).validate().responseJSON { response in
			if let userArray = response.result.value as? [[String: Any]] {
				let users = parse(userArray: userArray)
				completion?(true, nil, users)
			}
			if let error = response.error {
				print("💥 .GET allUsers API: \(error)")
				completion?(false, APIError(error: error, statusCode: response.response?.statusCode), nil)
			}
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func follow(friend: User, completion: ((Bool, APIError?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let user = AppDelegate.shared.user
		let tokenHeader: HTTPHeaders = ["Authorization": "Bearer \(user.token ?? "")"]
		let parameters: Parameters = ["userID" : friend.id ?? 666]
		Alamofire.request(baseURL + "follow", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: tokenHeader).validate().responseString { response in
			if let error = response.error {
				print("💥 .POST follow API: \(error)")
				completion?(false, APIError(error: error, statusCode: response.response?.statusCode))
			}
			completion?(true, nil)
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func unfollow(friend: User, completion: ((Bool, APIError?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let user = AppDelegate.shared.user
		let tokenHeader: HTTPHeaders = ["Authorization": "Bearer \(user.token ?? "")"]
		let parameters: Parameters = ["userID" : friend.id ?? 666]
		Alamofire.request(baseURL + "unfollow", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: tokenHeader).validate().responseString { response in
			if let error = response.error {
				print("💥 .POST unfollow API: \(error)")
				completion?(false, APIError(error: error, statusCode: response.response?.statusCode))
			}
			completion?(true, nil)
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func followers(completion: ((Bool, APIError?, [User]?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let user = AppDelegate.shared.user
		let tokenHeader: HTTPHeaders = ["Authorization": "Bearer \(user.token ?? "")"]
		Alamofire.request(baseURL + "followers", method: .get, headers: tokenHeader).validate().responseJSON { response in
			if let userArray = response.result.value as? [[String: Any]] {
				let users = parse(userArray: userArray)
				completion?(true, nil, users)
			}
			if let error = response.error {
				print("💥 .GET followers API: \(error)")
				completion?(false, APIError(error: error, statusCode: response.response?.statusCode), nil)
			}
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func following(completion: ((Bool, APIError?, [User]?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let user = AppDelegate.shared.user
		let tokenHeader: HTTPHeaders = ["Authorization": "Bearer \(user.token ?? "")"]
		Alamofire.request(baseURL + "following", method: .get, headers: tokenHeader).validate().responseJSON { response in
			if let userArray = response.result.value as? [[String: Any]] {
				let users = parse(userArray: userArray)
				completion?(true, nil, users)
			}
			if let error = response.error {
				print("💥 .GET following API: \(error)")
				completion?(false, APIError(error: error, statusCode: response.response?.statusCode), nil)
			}
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func search(term: String, completion: ((Bool, APIError?, [User]?) -> Void)?) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let user = AppDelegate.shared.user
		let tokenHeader: HTTPHeaders = ["Authorization": "Bearer \(user.token ?? "")"]
		let parameters: Parameters = ["search" : term]
		Alamofire.request(baseURL + "search", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: tokenHeader).validate().responseJSON { response in
			if let userArray = response.result.value as? [[String: Any]] {
				let users = parse(userArray: userArray)
				completion?(true, nil, users)
			}
			if let error = response.error {
				print("💥 .GET search API: \(error)")
				completion?(false, APIError(error: error, statusCode: response.response?.statusCode), nil)
			}
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	// MARK: Helper
	
	private static func parse(userArray: [[String: Any]]) -> [User] {
		var users: [User] = []
		for userDictionary in userArray {
			if let user = parse(userDictionary: userDictionary) {
				users.append(user)
			}
		}
		return users
	}
	
	private static func decode(sessionsArray: Any) -> [Session] {
		var sessions: [Session] = []
		do {
			let data = try JSONSerialization.data(withJSONObject: sessionsArray, options: [])
			let decoder = JSONDecoder()
			sessions = try decoder.decode([Session].self, from: data)
		} catch {
			print("💥 Sessions JSON Serialization \(error)")
		}
		return sessions
	}
	
	private static func parse(userDictionary: [String: Any]) -> User? {
		let user = User()
		if let name = userDictionary["name"] as? String {
			user.name = name
		}
		if let email = userDictionary["email"] as? String {
			user.email = email
		}
		if let photoURL = userDictionary["photoURL"] as? String {
			user.photoURL = photoURL
		}
		if let id = userDictionary["id"] as? Int {
			user.id = id
		}
		if let sessionsArray = userDictionary["sessions"] as? [Any] {
			user.sessions = decode(sessionsArray: sessionsArray)
		}
		return user
	}

	static func showAlertFor(reason: String, In viewController: UIViewController) {
		let alertController = UIAlertController(title: reason, message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "Ok", style: .default)
		alertController.addAction(action)
		viewController.present(alertController, animated: true, completion: nil)
	}
}
