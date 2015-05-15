import UIKit

struct Grade {
    let system: System
    let value: String
    let color: UIColor?
    let display: Bool
}

struct Color {
    static let BLUE = UIColor(hue:0.47, saturation:1, brightness:0.97, alpha:1)
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