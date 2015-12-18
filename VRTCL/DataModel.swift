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
    case UIAA
    case French
    case YDS
    case Font
    case Hueco
}

struct Climb {
    var style: Style
    var grade: Grade
}

enum Style {
    case Flash
    case OnSight
    case RedPoint
    case Attempt
    case Toprope
}

enum Kind {
    case SportClimbing
    case Bouldering
}

struct Session {
    let kind: Kind
    var climbs: [Climb]
    var feeling: Feeling
    var location: Location
    var duration: Double
    let date: Date
    let likes: Likes
    let comments: Comments
}

struct Date {
    let startDate: NSDate
    let endDate: NSDate
}

enum Feeling {
    case Fabolous
    case OK
    case Exhausted
    case Hideous
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
    var date: NSDate
}

struct Comments {
    var comments: [Comment]
    var count: Int {
        return comments.count
    }
}

struct Grades {
    static let UIAA: [Grade] = [
        Grade(system: .UIAA, value: "", color: nil, display: true),
        Grade(system: .UIAA, value: "", color: nil, display: true)
    ]
}

let grade = Grade(system: .UIAA, value: "5", color: Color.BLUE, display: true)

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

