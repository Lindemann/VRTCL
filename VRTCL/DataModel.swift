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
	let value: String
	let color: UIColor?
	let display: Bool
}

struct Color {
	static let BLUE = UIColor(red:0, green:0.97, blue:0.77, alpha:1)
}

enum System {
	case uiaa
	case french
	case yds
	case font
	case hueco
}

struct Climb {
	var style: Style
	var grade: Grade
}

enum Style {
	case flash
	case onSight
	case redPoint
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

struct Grades {
	static let UIAA: [Grade] = [
		Grade(system: .uiaa, value: "", color: nil, display: true),
		Grade(system: .uiaa, value: "", color: nil, display: true)
	]
}

let grade = Grade(system: .uiaa, value: "5", color: Color.BLUE, display: true)

struct User {
	var sessions: [Session]
	let account: Account
	let statistics: Statistics
}

struct Account {
	var userName: String
	var password: String
	var mail: String
	var image: UIImage
}

struct Statistics {

}
