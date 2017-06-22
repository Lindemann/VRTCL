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
	var index: Int? // Index in climbs array of session
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

struct Account {
	var userName: String
	var password: String
	var mail: String
	var image: UIImage
}

struct Statistics {
	
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
		Grade(system: .french, value: "4c", color: Colors.neonGreen, isRealGrade: true),
		
		Grade(system: .french, value: "5a", color: Colors.purple, isRealGrade: true),
		Grade(system: .french, value: "5a+", color: Colors.purple, isRealGrade: true),
		Grade(system: .french, value: "5b", color: Colors.purple, isRealGrade: true),
		Grade(system: .french, value: "5b+", color: Colors.purple, isRealGrade: true),
		Grade(system: .french, value: "5c", color: Colors.purple, isRealGrade: true),
		Grade(system: .french, value: "5c+", color: Colors.purple, isRealGrade: true),
		
		Grade(system: .french, value: "6a", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .french, value: "6a+", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .french, value: nil, color: nil, isRealGrade: false),
		Grade(system: .french, value: "6b", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .french, value: "6b+", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .french, value: "6c", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .french, value: "6c+", color: Colors.babyBlue, isRealGrade: true),
		
		Grade(system: .french, value: "7a", color: Colors.magenta, isRealGrade: true),
		Grade(system: .french, value: "7a+", color: Colors.magenta, isRealGrade: true),
		Grade(system: .french, value: "7b", color: Colors.magenta, isRealGrade: true),
		Grade(system: .french, value: "7b+", color: Colors.magenta, isRealGrade: true),
		Grade(system: .french, value: "7c", color: Colors.magenta, isRealGrade: true),
		Grade(system: .french, value: "7c+", color: Colors.magenta, isRealGrade: true),
		
		Grade(system: .french, value: "8a", color: Colors.mint, isRealGrade: true),
		Grade(system: .french, value: "8a+", color: Colors.mint, isRealGrade: true),
		Grade(system: .french, value: "8b", color: Colors.mint, isRealGrade: true),
		Grade(system: .french, value: "8b+", color: Colors.mint, isRealGrade: true),
		Grade(system: .french, value: "8c", color: Colors.mint, isRealGrade: true),
		Grade(system: .french, value: "8c+", color: Colors.mint, isRealGrade: true),
		
		Grade(system: .french, value: "9a", color: Colors.orange, isRealGrade: true),
		Grade(system: .french, value: "9a+", color: Colors.orange, isRealGrade: true),
		Grade(system: .french, value: "9b", color: Colors.orange, isRealGrade: true),
		Grade(system: .french, value: "9b+", color: Colors.orange, isRealGrade: true)
	]
	
	static let yds: [Grade] = [
		Grade(system: .yds, value: "5.2", color: Colors.discoBlue, isRealGrade: true),
		Grade(system: .yds, value: "5.3", color: Colors.discoBlue, isRealGrade: true),
		Grade(system: .yds, value: "5.4", color: Colors.discoBlue, isRealGrade: true),
		Grade(system: .yds, value: "5.5", color: Colors.discoBlue, isRealGrade: true),
		
		Grade(system: .yds, value: "5.6", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .yds, value: nil, color: nil, isRealGrade: false),
		Grade(system: .yds, value: "5.7", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .yds, value: nil, color: nil, isRealGrade: false),
		Grade(system: .yds, value: "5.8", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .yds, value: nil, color: nil, isRealGrade: false),
		Grade(system: .yds, value: "5.9", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .yds, value: nil, color: nil, isRealGrade: false),
		
		Grade(system: .yds, value: "5.10a", color: Colors.purple, isRealGrade: true),
		Grade(system: .yds, value: "5.10b", color: Colors.purple, isRealGrade: true),
		Grade(system: .yds, value: "5.10c", color: Colors.purple, isRealGrade: true),
		Grade(system: .yds, value: "5.10d", color: Colors.purple, isRealGrade: true),
		
		Grade(system: .yds, value: "5.11a", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .yds, value: "5.11b", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .yds, value: "5.11c", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .yds, value: "5.11d", color: Colors.babyBlue, isRealGrade: true),
		
		Grade(system: .yds, value: "5.12a", color: Colors.magenta, isRealGrade: true),
		Grade(system: .yds, value: "5.12b", color: Colors.magenta, isRealGrade: true),
		Grade(system: .yds, value: "5.12c", color: Colors.magenta, isRealGrade: true),
		Grade(system: .yds, value: "5.12d", color: Colors.magenta, isRealGrade: true),
		
		Grade(system: .yds, value: "5.13a", color: Colors.mint, isRealGrade: true),
		Grade(system: .yds, value: "5.13b", color: Colors.mint, isRealGrade: true),
		Grade(system: .yds, value: "5.13c", color: Colors.mint, isRealGrade: true),
		Grade(system: .yds, value: "5.13d", color: Colors.mint, isRealGrade: true),
		
		Grade(system: .yds, value: "5.14a", color: Colors.orange, isRealGrade: true),
		Grade(system: .yds, value: "5.14b", color: Colors.orange, isRealGrade: true),
		Grade(system: .yds, value: "5.14c", color: Colors.orange, isRealGrade: true),
		Grade(system: .yds, value: "5.14d", color: Colors.orange, isRealGrade: true),
		
		Grade(system: .yds, value: "5.15a", color: Colors.hardPurple, isRealGrade: true),
		Grade(system: .yds, value: "5.15b", color: Colors.hardPurple, isRealGrade: true),
		Grade(system: .yds, value: "5.15c", color: Colors.hardPurple, isRealGrade: true)
	]
	
	static let font: [Grade] = [
		Grade(system: .font, value: "3", color: Colors.neonGreen, isRealGrade: true),
		
		Grade(system: .font, value: "4-", color: Colors.purple, isRealGrade: true),
		Grade(system: .font, value: "4", color: Colors.purple, isRealGrade: true),
		Grade(system: .font, value: "4+", color: Colors.purple, isRealGrade: true),
		
		Grade(system: .font, value: "5-", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .font, value: "5", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .font, value: "5+", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .font, value: nil, color: nil, isRealGrade: false),
		
		Grade(system: .font, value: "6A", color: Colors.magenta, isRealGrade: true),
		Grade(system: .font, value: "6A+", color: Colors.magenta, isRealGrade: true),
		Grade(system: .font, value: "6B", color: Colors.magenta, isRealGrade: true),
		Grade(system: .font, value: "6B+", color: Colors.magenta, isRealGrade: true),
		Grade(system: .font, value: "6C", color: Colors.magenta, isRealGrade: true),
		Grade(system: .font, value: "6C+", color: Colors.magenta, isRealGrade: true),
		
		Grade(system: .font, value: "7A", color: Colors.mint, isRealGrade: true),
		Grade(system: .font, value: "7A+", color: Colors.mint, isRealGrade: true),
		Grade(system: .font, value: "7B", color: Colors.mint, isRealGrade: true),
		Grade(system: .font, value: "7B+", color: Colors.mint, isRealGrade: true),
		Grade(system: .font, value: "7C", color: Colors.mint, isRealGrade: true),
		Grade(system: .font, value: "7C+", color: Colors.mint, isRealGrade: true),
		
		Grade(system: .font, value: "8A", color: Colors.orange, isRealGrade: true),
		Grade(system: .font, value: "8A+", color: Colors.orange, isRealGrade: true),
		Grade(system: .font, value: "8B", color: Colors.orange, isRealGrade: true),
		Grade(system: .font, value: "8B+", color: Colors.orange, isRealGrade: true),
		Grade(system: .font, value: "8C", color: Colors.orange, isRealGrade: true),
		Grade(system: .font, value: "8C+", color: Colors.orange, isRealGrade: true),
	]
	
	static let hueco: [Grade] = [
		Grade(system: .hueco, value: "VB", color: Colors.discoBlue, isRealGrade: true),
		
		Grade(system: .hueco, value: "V0-", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .hueco, value: nil, color: nil, isRealGrade: false),
		Grade(system: .hueco, value: "V0", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .hueco, value: nil, color: nil, isRealGrade: false),
		Grade(system: .hueco, value: "V0+", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .hueco, value: nil, color: nil, isRealGrade: false),
		
		Grade(system: .hueco, value: "V1", color: Colors.purple, isRealGrade: true),
		Grade(system: .hueco, value: "V2", color: Colors.purple, isRealGrade: true),
		Grade(system: .hueco, value: "V3", color: Colors.purple, isRealGrade: true),
		Grade(system: .hueco, value: nil, color: nil, isRealGrade: false),
		
		Grade(system: .hueco, value: "V4", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .hueco, value: nil, color: nil, isRealGrade: false),
		Grade(system: .hueco, value: "V5", color: Colors.babyBlue, isRealGrade: true),
		Grade(system: .hueco, value: "V6", color: Colors.babyBlue, isRealGrade: true),
		
		Grade(system: .hueco, value: "V7", color: Colors.magenta, isRealGrade: true),
		Grade(system: .hueco, value: nil, color: nil, isRealGrade: false),
		Grade(system: .hueco, value: "V8", color: Colors.magenta, isRealGrade: true),
		Grade(system: .hueco, value: "V9", color: Colors.magenta, isRealGrade: true),
		
		Grade(system: .hueco, value: "V10", color: Colors.mint, isRealGrade: true),
		Grade(system: .hueco, value: "V11", color: Colors.mint, isRealGrade: true),
		Grade(system: .hueco, value: "V12", color: Colors.mint, isRealGrade: true),
		
		Grade(system: .hueco, value: "V13", color: Colors.orange, isRealGrade: true),
		Grade(system: .hueco, value: "V14", color: Colors.orange, isRealGrade: true),
		Grade(system: .hueco, value: "V15", color: Colors.orange, isRealGrade: true),
		
		Grade(system: .hueco, value: "V16", color: Colors.hardPurple, isRealGrade: true)
	]
	
	static let subjective: [Grade] = [
		Grade(system: .subjective, value: "easy", color: Colors.neonGreen, isRealGrade: true),
		Grade(system: .subjective, value: "medium", color: Colors.purple, isRealGrade: true),
		Grade(system: .subjective, value: "hard", color: Colors.mint, isRealGrade: true),
		Grade(system: .subjective, value: "extreme", color: Colors.orange, isRealGrade: true)
	]
}

class Session {
	let kind: Kind
	var climbs: [Climb]? = []
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

class User {
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
