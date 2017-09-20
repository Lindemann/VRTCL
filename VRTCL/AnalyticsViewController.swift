//
//  AnalyticsViewController.swift
//  VRTCL
//
//  Created by Lindemann on 22.08.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

internal class AnalyticsViewControllerViewModel {
    
    var kind: Kind = .sportClimbing
    
    var sessions: [Session]? {
		let sessions = kind == .sportClimbing ? AppDelegate.shared.user.sportClimbingSessions : AppDelegate.shared.user.boulderingSessions
		guard sessions.count > 0 else { return nil }
        return sessions
    }
	
	var newestSessions: [Session]? {
		guard var sessions = self.sessions else { return nil }
		let newestSessions = sessions[0...maxSessionsCountForCalculation - 1]
		return Array(newestSessions)
	}
    
    var maxSessionsCountForCalculation: Int {
		guard let count = sessions?.count  else { return 0 }
        return count >= 5 ? 5 : count
    }
    
    var onsightLevel: String {
		guard let newestSessions = newestSessions else { return "?"}
        var onSightsAndFlashesIndices: [Int] = []
        
        for session in newestSessions {
            if let climbs = session.climbs, climbs.count > 0 {
                for climb in climbs {
                    if climb.style == .onsight || climb.style == .flash {
                        if let index = GradeScales.indexFor(grade: climb.grade) {
                            onSightsAndFlashesIndices.append(index)
                        }
                    }
                }
            }
        }
    
        let max = onSightsAndFlashesIndices.max() ?? 0
        guard let gradeSystem = kind == .sportClimbing ? AppDelegate.shared.user.sportClimbingGradeSystem : AppDelegate.shared.user.boulderingGradeSystem else { return "?" }
        let resultGrade = GradeScales.gradeScaleFor(system: gradeSystem)[max]
        let normalizedResultGrade = resultGrade.isRealGrade ? resultGrade : GradeScales.gradeScaleFor(system: gradeSystem)[max - 1]
        return normalizedResultGrade.value ?? "?"
    }
    
    var performanceTrend: String {
        /*
         -1 (↓)              0 (→)              1 (↑)
         ------------------------------------------------
         < OSL              == OSL              > OSL
         < [0...33]     == [33...66]        > [66...100] (SR in %)
         
         Example:
         OSL = 5
         Routes = [3,4,5,6]
         -1 + -1 + 0 + 1 = -1
         SR = 90% -> 1
         Result = 0
         */
        guard let newestSessions = newestSessions else { return "?"}
        var onSightsAndFlashesIndices: [Int] = []
        
        for session in newestSessions {
            if let climbs = session.climbs, climbs.count > 0 {
                for climb in climbs {
                    if climb.style == .onsight || climb.style == .flash {
                        if let index = GradeScales.indexFor(grade: climb.grade) {
                            onSightsAndFlashesIndices.append(index)
                        }
                    }
                }
            }
        }
        // OSL Points
        let onsightLevelIndex = onSightsAndFlashesIndices.max() ?? 0
        var routesPoints = 0
        for onSightsAndFlashesIndex in onSightsAndFlashesIndices {
            switch true {
            case onSightsAndFlashesIndex < onSightsAndFlashesIndex:
                routesPoints += -1
            case onSightsAndFlashesIndex == onsightLevelIndex:
                routesPoints += 0
            case onSightsAndFlashesIndex > onsightLevelIndex:
                routesPoints += 1
            default:
                break
            }
        }
        
        // SR Points
        let successRate = self.successRate
        var successRatePoints = 0
        switch true {
        case 0..<33 ~= successRate:
            successRatePoints += -1
        case 33..<66 ~= successRate:
            successRatePoints += 0
        case 66...100 ~= successRate:
            successRatePoints += 1
        default:
            break
        }
        
        // Result
        var result = ""
        switch true {
        case (routesPoints + successRatePoints) < 0:
            result = "↓"
        case (routesPoints + successRatePoints) == 0:
            result = "→"
        case (routesPoints + successRatePoints) > 0:
            result = "↑"
        default:
            break
        }
        return result
    }
    
    var hoursPerSession: String {
        guard let newestSessions = newestSessions else { return "?"}
        var counter = 0
        for session in newestSessions {
            counter += session.duration ?? 0
        }
        return "\(counter / maxSessionsCountForCalculation)"
    }
    
    var climbsPerSession: String {
        guard let newestSessions = newestSessions else { return "?"}
        var counter = 0
        for session in newestSessions {
            counter += session.climbs?.count ?? 0
        }
        return "\(counter / newestSessions.count)"
    }
    
    var leadRate: Int {
        guard let newestSessions = newestSessions else { return 0}
        var leadedClimbs = 0
        var allClimbs = 0
        for session in newestSessions {
            if let climbs = session.climbs, climbs.count > 0 {
                allClimbs += climbs.count
                for climb in climbs {
                    switch climb.style {
                    case .onsight?, .flash?, .redpoint?, .attempt? :
                        leadedClimbs += 1
                    default:
                        break
                    }
                }
            }
        }
        return (leadedClimbs * 100) / allClimbs
    }
    
    var successRate: Int {
        guard let newestSessions = newestSessions else { return 0}
        var successfulClimbs = 0
        var allClimbs = 0
        for session in newestSessions {
            if let climbs = session.climbs, climbs.count > 0 {
                allClimbs += climbs.count
                for climb in climbs {
                    switch climb.style {
                    case .onsight?, .flash?, .redpoint? :
                        successfulClimbs += 1
                    default:
                        break
                    }
                }
            }
        }
        return (successfulClimbs * 100) / allClimbs
    }
}

class AnalyticsViewController: UIViewController {

    let viewModel = AnalyticsViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.darkGray
        
        // SegmentedControl
        let segmentedControl = UISegmentedControl(items: ["Sport Climbing", "Bouldering"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = Colors.lightGray
        segmentedControl.addTarget(self, action: #selector(changeKind(sender:)), for: .valueChanged)
        segmentedControl.setWidth(120, forSegmentAt: 0)
        segmentedControl.setWidth(120, forSegmentAt: 1)
        navigationItem.titleView = segmentedControl
        
        setupSportclimbingAnalytics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.kind == .sportClimbing ? setupSportclimbingAnalytics() : setupBoulderingAnalytics()
    }

    @objc private func changeKind(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.kind = .sportClimbing
            setupSportclimbingAnalytics()
        default:
            viewModel.kind = .bouldering
            setupBoulderingAnalytics()
        }
    }
    
    private func setupSportclimbingAnalytics() {
        
        view.subviews.forEach({ $0.removeFromSuperview() })

        let onsightLevel = CircleButtonWithText(mode: .outlinedLarge, buttonText: viewModel.onsightLevel, labelText: "Onsight Level")
        let performanceTrend = CircleButtonWithText(mode: .outlinedLarge, buttonText: viewModel.performanceTrend, labelText: "Performance Trend")
        let stackView01 = UIStackView(arrangedSubviews: [onsightLevel, performanceTrend])
        stackView01.axis = .horizontal

        let hoursPerWeek = CircleButtonWithText(mode: .outlinedLarge, buttonText: viewModel.hoursPerSession, labelText: "Hours per Session")
        let routesPerSession = CircleButtonWithText(mode: .outlinedLarge, buttonText: viewModel.climbsPerSession, labelText: "Routes per Session")
        let stackView02 = UIStackView(arrangedSubviews: [hoursPerWeek, routesPerSession])
        stackView02.axis = .horizontal

        onsightLevel.isUserInteractionEnabled = false
        performanceTrend.isUserInteractionEnabled = false
        hoursPerWeek.isUserInteractionEnabled = false
        routesPerSession.isUserInteractionEnabled = false

        let leadRate = PieChartView(percentage: Double(viewModel.leadRate), text: "Lead Rate", color: Colors.mint)
        let successRate = PieChartView(percentage: Double(viewModel.successRate), text: "Success Rate", color: Colors.neonGreen)
        let stackView03 = UIStackView(arrangedSubviews: [leadRate, successRate])
        stackView03.axis = .horizontal
        
        let containerStackView = UIStackView(arrangedSubviews: [stackView01, stackView02, stackView03])
        containerStackView.spacing = 30
        containerStackView.axis = .vertical
        view.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupBoulderingAnalytics() {
        
        view.subviews.forEach({ $0.removeFromSuperview() })
        
        let onsightLevel = CircleButtonWithText(mode: .outlinedLarge, buttonText: viewModel.onsightLevel, labelText: "Onsight Level")
        let performanceTrend = CircleButtonWithText(mode: .outlinedLarge, buttonText: viewModel.performanceTrend, labelText: "Performance Trend")
        let stackView01 = UIStackView(arrangedSubviews: [onsightLevel, performanceTrend])
        stackView01.axis = .horizontal
        stackView01.translatesAutoresizingMaskIntoConstraints = false
        stackView01.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        let hoursPerWeek = CircleButtonWithText(mode: .outlinedLarge, buttonText: viewModel.hoursPerSession, labelText: "Hours per Session")
        let boulderPerSession = CircleButtonWithText(mode: .outlinedLarge, buttonText: viewModel.climbsPerSession, labelText: "Boulder per Session")
        let stackView02 = UIStackView(arrangedSubviews: [hoursPerWeek, boulderPerSession])
        stackView02.axis = .horizontal
        
        onsightLevel.isUserInteractionEnabled = false
        performanceTrend.isUserInteractionEnabled = false
        hoursPerWeek.isUserInteractionEnabled = false
        boulderPerSession.isUserInteractionEnabled = false
        
        let successRate = PieChartView(percentage: Double(viewModel.successRate), text: "Success Rate", color: Colors.neonGreen)
        let stackView03 = UIStackView(arrangedSubviews: [successRate])
        stackView03.axis = .horizontal
        
        let containerStackView = UIStackView(arrangedSubviews: [stackView01, stackView02, stackView03])
        containerStackView.spacing = 30
        containerStackView.axis = .vertical
        view.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}











