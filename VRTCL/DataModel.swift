//
//  DataModel.swift
//  VRTCL
//
//  Created by Lindemann on 15/10/15.
//  Copyright © 2015 Lindemann. All rights reserved.
//

import UIKit

struct Grade {
	let system: System
	let value: String?
	let color: UIColor?
	let display: Bool
}

enum System: String {
	case uiaa = "UIAA"
	case french = "French"
	case yds = "YDS"
	case font = "Font"
	case hueco = "Hueco"
	case subjective = "Subjective"
}

struct Climb {
	var style: Style
	var grade: Grade
}

enum Style {
	case flash
	case onsight
	case redpoint
	case attempt
	case toprope
}

enum Kind {
	case sportClimbing
	case bouldering
}

struct Session {
	let kind: Kind
	var climbs: [Climb]?
	var feeling: Feeling?
	var location: Location?
	var duration: Double?
	var date: Date?
	var likes: Likes?
	var comments: Comments?
	
	init(kind: Kind) {
		self.kind = kind
	}
}

struct Date {
	let startDate: Foundation.Date
	let endDate: Foundation.Date
}

enum Feeling {
	case fabolous
	case ok
	case exhausted
	case hideous
}

struct Location {
	var name: String
	var geoLocation: Int
}

struct Likes {
	var users: [User]
	var count: Int {
		return users.count
	}
}

struct Comment {
	var text: String
	var user: User
	var date: Foundation.Date
}

struct Comments {
	var comments: [Comment]
	var count: Int {
		return comments.count
	}
}

struct GradeScales {
	static let uiaa: [Grade] = [
		Grade(system: .uiaa, value: "3-", color: Colors.mauve, display: true),
		Grade(system: .uiaa, value: "3", color: Colors.mauve, display: true),
		Grade(system: .uiaa, value: "3+", color: Colors.mauve, display: true),
		
		Grade(system: .uiaa, value: "4-", color: Colors.discoBlue, display: true),
		Grade(system: .uiaa, value: "4", color: Colors.discoBlue, display: true),
		Grade(system: .uiaa, value: "4+", color: Colors.discoBlue, display: true),
		
		Grade(system: .uiaa, value: "5-", color: Colors.neonGreen, display: true),
		Grade(system: .uiaa, value: "5", color: Colors.neonGreen, display: true),
		Grade(system: .uiaa, value: "5+", color: Colors.neonGreen, display: true),
		Grade(system: .uiaa, value: nil, color: nil, display: false)
	]
	
	static let french: [Grade] = [
		Grade(system: .french, value: "3a", color: Colors.neonGreen, display: true),
		Grade(system: .french, value: "3b", color: Colors.neonGreen, display: true),
		Grade(system: .french, value: "3b", color: Colors.neonGreen, display: true),
		Grade(system: .french, value: "4a", color: Colors.neonGreen, display: true),
		Grade(system: .french, value: "4b", color: Colors.neonGreen, display: true),
		Grade(system: .french, value: "4c", color: Colors.neonGreen, display: true)
	]
	
	static let yds: [Grade] = [
		Grade(system: .yds, value: "5.2", color: Colors.discoBlue, display: true),
		Grade(system: .yds, value: "5.3", color: Colors.discoBlue, display: true),
		Grade(system: .yds, value: "5.4", color: Colors.discoBlue, display: true),
		Grade(system: .yds, value: "5.5", color: Colors.discoBlue, display: true),
		Grade(system: .yds, value: "5.6", color: Colors.discoBlue, display: true),
		Grade(system: .yds, value: nil, color: nil, display: false)
	]
}

struct User {
	var sessions: [Session]?
	
	let ud_defaultBoulderingGradeSystem = "ud_defaultBoulderingGradeSystem"
	let ud_defaultSportClimbingGradeSystem = "ud_defaultSportClimbingGradeSystem"
	var defaultBoulderingGradeSystem: System? {
		set {
			UserDefaults().set(newValue, forKey: ud_defaultBoulderingGradeSystem)
		}
		get {
			let rawValue = UserDefaults().string(forKey: ud_defaultBoulderingGradeSystem)
			return System(rawValue: rawValue ?? "Font")
		}
	}
	var defaultSportClimbingGradeSystem: System? {
		set {
			UserDefaults().set(newValue, forKey: ud_defaultSportClimbingGradeSystem)
		}
		get {
			let rawValue = UserDefaults().string(forKey: ud_defaultSportClimbingGradeSystem)
			return System(rawValue: rawValue ?? "UIAA")
		}
	}
}

struct Account {
	var userName: String
	var password: String
	var mail: String
	var image: UIImage
}

struct Statistics {

}
