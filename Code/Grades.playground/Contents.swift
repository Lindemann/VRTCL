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

let grade = Grade(system: .UIAA, value: "5", color: Color.BLUE, display: true)
Grade(system: .UIAA, value: "5-/5+", color: nil, display: false)

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
    var climbs: Array<Climb>
    var feeling: Feeling
    var location: Location
    var duration: Double
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

struct Grades {
    static let UIAA: [Grade] = [
        Grade(system: .UIAA, value: "", color: nil, display: true),
        Grade(system: .UIAA, value: "", color: nil, display: true)
    ]
}

println(Grades.UIAA)
