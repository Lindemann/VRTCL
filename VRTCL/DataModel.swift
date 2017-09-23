//
//  DataModel.swift
//  VRTCL
//
//  Created by Lindemann on 15/10/15.
//  Copyright © 2015 Lindemann. All rights reserved.
//

import UIKit
import CoreLocation

struct Grade: Codable, Equatable {
	let system: System
	let value: String?
	let color: String?
	// Should be Bool but thanks to JSONSerialization which turns all bools to int its not possible at the moment...
	// TODO: Change to Bool when Alamofire supports Codable
	let isRealGrade: Int
	
	static func == (left: Grade, right: Grade) -> Bool {
		return left.system == right.system && left.value == right.value
	}
}

enum System: String, Codable {
	case uiaa = "UIAA"
	case french = "French"
	case yds = "YDS"
	case font = "Font"
	case hueco = "Hueco"
	case subjective = "Subjective"
}

struct Climb: Codable {
	var style: Style?
	var grade: Grade?
	var index: Int? // Index in climbs array of session
}

enum Style: String, Codable {
	case onsight = "On Sight"
	case flash = "Flash"
	case redpoint = "Redpoint"
	case attempt = "Attempt"
	case toprope = "Toprope"
}

enum Kind: String, Codable {
	case sportClimbing
	case bouldering
}

enum Mood: String, Codable {
	case good
	case nah
	case dead
}

struct Location: Codable {
	enum Venue: String, Codable {
		case gym = "Gym"
		case outdoor = "Outdoor"
	}
	
	struct Coordinate: Codable {
		let latitude: Double
		let longitude: Double
	}
	
	var venue: Venue?
	var name: String?
	var coordinate: Coordinate?
}

struct Likes: Codable {
	var users: [User]
	var count: Int {
		return users.count
	}
}

struct Comment: Codable {
	var text: String
	var user: User
	var date: Date
}

struct Comments: Codable {
	var comments: [Comment]
	var count: Int {
		return comments.count
	}
}

struct Account: Codable {
	var userName: String
	var password: String
	var mail: String
	var imageURL: String
}

struct Statistics {
	static func bestEffort(session: Session) -> Climb? {
		guard let climbs = session.climbs else { return nil }
		var realEfforts: [Climb] = []
		for climb in climbs {
			if let style = climb.style {
				switch style {
				case .toprope, .attempt:
					continue
				default:
					realEfforts.append(climb)
				}
			}
		}
		var tmpBestEffort: Climb? = nil
		if realEfforts.count == 0 { return nil }
		for i in 0...realEfforts.count - 1 {
			if tmpBestEffort == nil {
				tmpBestEffort = realEfforts[i]
			}
			if GradeScales.indexFor(grade: realEfforts[i].grade) ?? 0 > GradeScales.indexFor(grade: tmpBestEffort?.grade) ?? 0 {
				tmpBestEffort = realEfforts[i]
			}
		}
		return tmpBestEffort
	}
}

struct GradeScales: Codable {
	
	static func gradeScaleFor(system: System) -> [Grade] {
		switch system {
		case .uiaa:
			return GradeScales.uiaa
		case .french:
			return GradeScales.french
		case .yds:
			return GradeScales.yds
		case .font:
			return GradeScales.font
		case .hueco:
			return GradeScales.hueco
		case .subjective:
			return GradeScales.subjective
		}
	}
	
	static func gradeFor(system: System, value: String) -> Grade? {
		for grade in GradeScales.gradeScaleFor(system: system) {
			if grade.value == value {
				return grade
			}
		}
		return nil
	}
	
	static func indexFor(grade: Grade?) -> Int? {
		guard let grade = grade else { return nil }
		switch grade.system {
		case .uiaa:
			return GradeScales.uiaa.index(of: grade)
		case .french:
			return GradeScales.french.index(of: grade)
		case .yds:
			return GradeScales.yds.index(of: grade)
		case .font:
			return GradeScales.font.index(of: grade)
		case .hueco:
			return GradeScales.hueco.index(of: grade)
		case .subjective:
			return GradeScales.subjective.index(of: grade)
		}
	}
	
	static let uiaa: [Grade] = [
		Grade(system: .uiaa, value: "3-", color: Colors.mauve.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "3", color: Colors.mauve.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "3+", color: Colors.mauve.toHexString, isRealGrade: 1),
		
		Grade(system: .uiaa, value: "4-", color: Colors.discoBlue.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "4", color: Colors.discoBlue.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "4+", color: Colors.discoBlue.toHexString, isRealGrade: 1),
		
		Grade(system: .uiaa, value: "5-", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "5", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "5+", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: nil, color: nil, isRealGrade: 0),
		
		Grade(system: .uiaa, value: "6-", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "6", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "6+", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: nil, color: nil, isRealGrade: 0),
		
		Grade(system: .uiaa, value: "7-", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "7", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "7+", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: nil, color: nil, isRealGrade: 0),
		
		Grade(system: .uiaa, value: "8-", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "8", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "8+", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: nil, color: nil, isRealGrade: 0),
		
		Grade(system: .uiaa, value: "9-", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "9", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "9+", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: nil, color: nil, isRealGrade: 0),
		
		Grade(system: .uiaa, value: "10-", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "10", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "10+", color: Colors.orange.toHexString, isRealGrade: 1),
		
		Grade(system: .uiaa, value: "11-", color: Colors.hardPurple.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: nil, color: nil, isRealGrade: 0),
		Grade(system: .uiaa, value: "11", color: Colors.hardPurple.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "11+", color: Colors.hardPurple.toHexString, isRealGrade: 1),
		
		Grade(system: .uiaa, value: "12-", color: Colors.pink.toHexString, isRealGrade: 1),
		Grade(system: .uiaa, value: "12", color: Colors.pink.toHexString, isRealGrade: 1),
	]
	
	static let french: [Grade] = [
		Grade(system: .french, value: "3a", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "3b", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "3c", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "4a", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "4b", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "4c", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		
		Grade(system: .french, value: "5a", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "5a+", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "5b", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "5b+", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "5c", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "5c+", color: Colors.purple.toHexString, isRealGrade: 1),
		
		Grade(system: .french, value: "6a", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "6a+", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .french, value: nil, color: nil, isRealGrade: 0),
		Grade(system: .french, value: "6b", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "6b+", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "6c", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "6c+", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		
		Grade(system: .french, value: "7a", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "7a+", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "7b", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "7b+", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "7c", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "7c+", color: Colors.magenta.toHexString, isRealGrade: 1),
		
		Grade(system: .french, value: "8a", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "8a+", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "8b", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "8b+", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "8c", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "8c+", color: Colors.mint.toHexString, isRealGrade: 1),
		
		Grade(system: .french, value: "9a", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "9a+", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "9b", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .french, value: "9b+", color: Colors.orange.toHexString, isRealGrade: 1)
	]
	
	static let yds: [Grade] = [
		Grade(system: .yds, value: "5.2", color: Colors.discoBlue.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.3", color: Colors.discoBlue.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.4", color: Colors.discoBlue.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.5", color: Colors.discoBlue.toHexString, isRealGrade: 1),
		
		Grade(system: .yds, value: "5.6", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: nil, color: nil, isRealGrade: 0),
		Grade(system: .yds, value: "5.7", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: nil, color: nil, isRealGrade: 0),
		Grade(system: .yds, value: "5.8", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: nil, color: nil, isRealGrade: 0),
		Grade(system: .yds, value: "5.9", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: nil, color: nil, isRealGrade: 0),
		
		Grade(system: .yds, value: "5.10a", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.10b", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.10c", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.10d", color: Colors.purple.toHexString, isRealGrade: 1),
		
		Grade(system: .yds, value: "5.11a", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.11b", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.11c", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.11d", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		
		Grade(system: .yds, value: "5.12a", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.12b", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.12c", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.12d", color: Colors.magenta.toHexString, isRealGrade: 1),
		
		Grade(system: .yds, value: "5.13a", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.13b", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.13c", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.13d", color: Colors.mint.toHexString, isRealGrade: 1),
		
		Grade(system: .yds, value: "5.14a", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.14b", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.14c", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.14d", color: Colors.orange.toHexString, isRealGrade: 1),
		
		Grade(system: .yds, value: "5.15a", color: Colors.hardPurple.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.15b", color: Colors.hardPurple.toHexString, isRealGrade: 1),
		Grade(system: .yds, value: "5.15c", color: Colors.hardPurple.toHexString, isRealGrade: 1)
	]
	
	static let font: [Grade] = [
		Grade(system: .font, value: "3", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		
		Grade(system: .font, value: "4-", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "4", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "4+", color: Colors.purple.toHexString, isRealGrade: 1),
		
		Grade(system: .font, value: "5-", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "5", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "5+", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .font, value: nil, color: nil, isRealGrade: 0),
		
		Grade(system: .font, value: "6A", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "6A+", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "6B", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "6B+", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "6C", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "6C+", color: Colors.magenta.toHexString, isRealGrade: 1),
		
		Grade(system: .font, value: "7A", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "7A+", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "7B", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "7B+", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "7C", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "7C+", color: Colors.mint.toHexString, isRealGrade: 1),
		
		Grade(system: .font, value: "8A", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "8A+", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "8B", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "8B+", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "8C", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .font, value: "8C+", color: Colors.orange.toHexString, isRealGrade: 1),
	]
	
	static let hueco: [Grade] = [
		Grade(system: .hueco, value: "VB", color: Colors.discoBlue.toHexString, isRealGrade: 1),
		
		Grade(system: .hueco, value: "V0-", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: nil, color: nil, isRealGrade: 0),
		Grade(system: .hueco, value: "V0", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: nil, color: nil, isRealGrade: 0),
		Grade(system: .hueco, value: "V0+", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: nil, color: nil, isRealGrade: 0),
		
		Grade(system: .hueco, value: "V1", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: "V2", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: "V3", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: nil, color: nil, isRealGrade: 0),
		
		Grade(system: .hueco, value: "V4", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: nil, color: nil, isRealGrade: 0),
		Grade(system: .hueco, value: "V5", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: "V6", color: Colors.babyBlue.toHexString, isRealGrade: 1),
		
		Grade(system: .hueco, value: "V7", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: nil, color: nil, isRealGrade: 0),
		Grade(system: .hueco, value: "V8", color: Colors.magenta.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: "V9", color: Colors.magenta.toHexString, isRealGrade: 1),
		
		Grade(system: .hueco, value: "V10", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: "V11", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: "V12", color: Colors.mint.toHexString, isRealGrade: 1),
		
		Grade(system: .hueco, value: "V13", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: "V14", color: Colors.orange.toHexString, isRealGrade: 1),
		Grade(system: .hueco, value: "V15", color: Colors.orange.toHexString, isRealGrade: 1),
		
		Grade(system: .hueco, value: "V16", color: Colors.hardPurple.toHexString, isRealGrade: 1)
	]
	
	static let subjective: [Grade] = [
		Grade(system: .subjective, value: "easy", color: Colors.neonGreen.toHexString, isRealGrade: 1),
		Grade(system: .subjective, value: "medium", color: Colors.purple.toHexString, isRealGrade: 1),
		Grade(system: .subjective, value: "hard", color: Colors.mint.toHexString, isRealGrade: 1),
		Grade(system: .subjective, value: "extreme", color: Colors.orange.toHexString, isRealGrade: 1)
	]
}

class Session: Codable {
	let kind: Kind
	var climbs: [Climb]? = []
	var mood: Mood?
	var location: Location? = Location()
	var duration: Int?
	var date: Date?
	var likes: Likes?
	var comments: Comments?
	
	init(kind: Kind) {
		self.kind = kind
	}
}

class User: Codable {
	
	static let shared = User()
	var sessions: [Session] = []
	var following: [User] = []
	var followers: [User] = []
	var isAuthenticated: Bool { return token != nil }
	
	var photoURL: String? {
		get { return UserDefaults().string(forKey: "photoURL") }
		set { UserDefaults().set(newValue, forKey: "photoURL") }
	}
	
	var id: String? {
		get { return UserDefaults().string(forKey: "id") }
		set { UserDefaults().set(newValue, forKey: "id") }
	}
	
	var name: String? {
		get { return UserDefaults().string(forKey: "name") }
		set { UserDefaults().set(newValue, forKey: "name") }
	}
	
	var email: String? {
		get { return UserDefaults().string(forKey: "email") }
		set { UserDefaults().set(newValue, forKey: "email") }
	}
	
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
	
	func saveCrdentials(email: String, password: String, name: String, token: String) {
		do {
			let passwordItem = KeychainPasswordItem(service: "VRTCL", account: email, accessGroup: nil)
			try passwordItem.savePassword(password)
			
			self.email = email
			self.token = token
			self.name = name
			
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
}





























