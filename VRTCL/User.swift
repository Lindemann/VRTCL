//
//  User.swift
//  VRTCL
//
//  Created by Lindemann on 25.09.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import Foundation

class User: Codable {
	
	static let shared = User()
	var sessions: [Session] = []
	var isAuthenticated: Bool { return token != nil }
	var photoURL: String?
	var id: Int?
	var name: String?
	var email: String?
	var token: String? {
		get { return UserDefaults().string(forKey: "token") }
		set { UserDefaults().set(newValue, forKey: "token") }
	}
	var password: String? {
		do {
			let email = UserDefaults().string(forKey: "email") ?? ""
			let passwordItem = KeychainPasswordItem(service:"VRTCL", account: email, accessGroup: nil)
			let keychainPassword = try passwordItem.readPassword()
			return keychainPassword
		}
		catch {
			fatalError("Error reading password from keychain - \(error)")
		}
	}
	
	private let ud_boulderingGradeSystem = "ud_boulderingGradeSystem"
	private let ud_sportClimbingGradeSystem = "ud_sportClimbingGradeSystem"
	var boulderingGradeSystem: System? {
		set { UserDefaults().set(newValue?.rawValue, forKey: ud_boulderingGradeSystem) }
		get {
			let rawValue = UserDefaults().string(forKey: ud_boulderingGradeSystem)
			return System(rawValue: rawValue ?? "Font")
		}
	}
	var sportClimbingGradeSystem: System? {
		set { UserDefaults().set(newValue?.rawValue, forKey: ud_sportClimbingGradeSystem) }
		get {
			let rawValue = UserDefaults().string(forKey: ud_sportClimbingGradeSystem)
			return System(rawValue: rawValue ?? "UIAA")
		}
	}
	
	var boulderingSessions: [Session] { return sessionsFor(kind: .bouldering) }
	var sportClimbingSessions: [Session] { return sessionsFor(kind: .sportClimbing) }
	
	// For Alamofire...it needs [String : Any] as parameters type
	// TODO: Remove when Alamofire supports Codable
	var sessionsJSON: [String : Any]? {
		let encoder = JSONEncoder()
		do {
			let data = try encoder.encode(sessions)
			let json = try JSONSerialization.jsonObject(with: data, options: [])
			return ["sessions" : json]
		} catch {
			print("💥 \(error)")
		}
		return nil
	}
	
	private func sessionsFor(kind: Kind) -> [Session] {
		var sessions: [Session] = []
		for session in self.sessions {
			if session.kind == kind {
				sessions.append(session)
			}
		}
		return sessions
	}
	
	// Used to setup loged in user
	func setupFromUserDefaults() {
		User.shared.photoURL = UserDefaults().string(forKey: "photoURL")
		User.shared.email = UserDefaults().string(forKey: "email")
		User.shared.name = UserDefaults().string(forKey: "name")
		User.shared.token = UserDefaults().string(forKey: "token")
		User.shared.id = UserDefaults().integer(forKey: "id")
	}
	
	// Used to initalize friends from API
	convenience init(name: String, email: String, id: Int, photoURL: String? = nil, sessions: [Session]? = nil) {
		self.init()
		self.name = name
		self.email = email
		self.id = id
		self.photoURL = photoURL
		self.sessions = sessions ?? []
	}
	
	func saveCrdentials(email: String, password: String, name: String, token: String, photoURL: String?, id: Int) {
		do {
			let passwordItem = KeychainPasswordItem(service: "VRTCL", account: email, accessGroup: nil)
			try passwordItem.savePassword(password)
			
			UserDefaults().set(email, forKey: "email")
			UserDefaults().set(token, forKey: "token")
			UserDefaults().set(name, forKey: "name")
			UserDefaults().set(photoURL, forKey: "photoURL")
			UserDefaults().set(id, forKey: "id")
			
		} catch {
			fatalError("Error updating keychain - \(error)")
		}
	}
	
	func logout() {
		// Destroy UserDefaults -> isAuthenticated == 0
		let appDomain = Bundle.main.bundleIdentifier!
		UserDefaults.standard.removePersistentDomain(forName: appDomain)
		sessions = []
		JsonIO.save(codable: sessions) //To destroy the old file
	}
	
	func updateSessionsWithAPI() {
		APIController.getSessions { (success, error, sessions) in
			if success {
				guard let sessions = sessions else { return }
				// Download sessions from Server when
				// - no sessions on device
				// - fewer sessions on device than on Server
				if sessions.count > self.sessions.count {
					self.sessions = sessions
				}
				// Upload sessions from device to Server wehen more sessions are on desvice
				// Happens when last upload failed
				if self.sessions.count > sessions.count {
					APIController.postSessions(completion: nil)
				}
			}
		}
	}
	
	var following: [User]? = []
	var followers: [User]? = []
}

























