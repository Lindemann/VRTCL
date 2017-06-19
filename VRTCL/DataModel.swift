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
	let isRealGrade: Bool
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
	var style: Style?
	var grade: Grade?
}

enum Style: String {
	case flash = "Flash"
	case onsight = "On Sight"
	case redpoint = "Redpoint"
	case attempt = "Attempt"
	case toprope = "Toprope"
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
	
	static let uiaa: [Grade] = [
		Grade(system: .uiaa, value: "3-", color: Colors.mauve, isRealGrade: true),
		Grade(system: .uiaa, value: "3", color: Colors.mauve, isRealGrade: true),
		Grade(system: .uiaa, value: "3+", color: Colors.mauve, isRealGrade: true),
		
		Grade(system: .uiaa, value: "4-", color: Colors.discoBlue, isRealGrade: true),
		Grade(system: .uiaa, value: "4", color: Colors.discoBlue, isRealGrade: true),
		Grade(system: .uiaa, value: "4+", color: Colors.discoBlue, isRealGrade: true),
		
		Grade(system: .uiaa, value: "5-", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .uiaa, value: "5", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .uiaa, value: "5+", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .uiaa, value: nil, color: nil, isRealGrade: false),
		
		Grade(system: .uiaa, value: "6-", color: Colors.purple, isRealGrade: true),
		Grade(system: .uiaa, value: "6", color: Colors.purple, isRealGrade: true),
		Grade(system: .uiaa, value: "6+", color: Colors.purple, isRealGrade: true),
		Grade(system: .uiaa, value: nil, color: nil, isRealGrade: false),
		
		Grade(system: .uiaa, value: "7-", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .uiaa, value: "7", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .uiaa, value: "7+", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .uiaa, value: nil, color: nil, isRealGrade: false),
		
		Grade(system: .uiaa, value: "8-", color: Colors.magenta, isRealGrade: true),
		Grade(system: .uiaa, value: "8", color: Colors.magenta, isRealGrade: true),
		Grade(system: .uiaa, value: "8+", color: Colors.magenta, isRealGrade: true),
		Grade(system: .uiaa, value: nil, color: nil, isRealGrade: false),
		
		Grade(system: .uiaa, value: "9-", color: Colors.mint, isRealGrade: true),
		Grade(system: .uiaa, value: "9", color: Colors.mint, isRealGrade: true),
		Grade(system: .uiaa, value: "9+", color: Colors.mint, isRealGrade: true),
		Grade(system: .uiaa, value: nil, color: nil, isRealGrade: false),
		
		Grade(system: .uiaa, value: "10-", color: Colors.orange, isRealGrade: true),
		Grade(system: .uiaa, value: "10", color: Colors.orange, isRealGrade: true),
		Grade(system: .uiaa, value: "10+", color: Colors.orange, isRealGrade: true),
		
		Grade(system: .uiaa, value: "11-", color: Colors.hardPurple, isRealGrade: true),
		Grade(system: .uiaa, value: nil, color: nil, isRealGrade: false),
		Grade(system: .uiaa, value: "11", color: Colors.hardPurple, isRealGrade: true),
		Grade(system: .uiaa, value: "11+", color: Colors.hardPurple, isRealGrade: true),
		
		Grade(system: .uiaa, value: "12-", color: Colors.pink, isRealGrade: true),
		Grade(system: .uiaa, value: "12", color: Colors.pink, isRealGrade: true),
	]
	
	static let french: [Grade] = [
		Grade(system: .french, value: "3a", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .french, value: "3b", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .french, value: "3b", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .french, value: "4a", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .french, value: "4b", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .french, value: "4c", color: Colors.neonGreen, isRealGrade: true)
	]
	
	static let yds: [Grade] = [
		Grade(system: .yds, value: "5.2", color: Colors.discoBlue, isRealGrade: true),
		Grade(system: .yds, value: "5.3", color: Colors.discoBlue, isRealGrade: true),
		Grade(system: .yds, value: "5.4", color: Colors.discoBlue, isRealGrade: true),
		Grade(system: .yds, value: "5.5", color: Colors.discoBlue, isRealGrade: true),
		Grade(system: .yds, value: "5.6", color: Colors.discoBlue, isRealGrade: true),
		Grade(system: .yds, value: nil, color: nil, isRealGrade: false)
	]
	
	static let font: [Grade] = [
		Grade(system: .font, value: "?", color: Colors.discoBlue, isRealGrade: true)
	]
	
	static let hueco: [Grade] = [
		Grade(system: .hueco, value: "?", color: Colors.discoBlue, isRealGrade: true)
	]
	
	static let subjective: [Grade] = [
		Grade(system: .subjective, value: "easy", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .subjective, value: "medium", color: Colors.purple, isRealGrade: true),
		Grade(system: .subjective, value: "hard", color: Colors.mint, isRealGrade: true),
		Grade(system: .subjective, value: "extreme", color: Colors.orange, isRealGrade: true)
	]
}

struct User {
	var sessions: [Session]?
	
	let ud_boulderingGradeSystem = "ud_boulderingGradeSystem"
	let ud_sportClimbingGradeSystem = "ud_sportClimbingGradeSystem"
	var boulderingGradeSystem: System? {
		set {
			UserDefaults().set(newValue?.rawValue, forKey: ud_boulderingGradeSystem)
		}
		get {
			let rawValue = UserDefaults().string(forKey: ud_boulderingGradeSystem)
			return System(rawValue: rawValue ?? "Font")
		}
	}
	var sportClimbingGradeSystem: System? {
		set {
			UserDefaults().set(newValue?.rawValue, forKey: ud_sportClimbingGradeSystem)
		}
		get {
			let rawValue = UserDefaults().string(forKey: ud_sportClimbingGradeSystem)
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
