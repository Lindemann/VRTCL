//
//  AnalyticsViewController.swift
//  VRTCL
//
//  Created by Lindemann on 22.08.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit
import ResearchKit

internal class AnalyticsViewControllerModel {
    var onsightLevel: String {
        return "6"
    }
    
    var performanceTrend: String {
        return "↑"
    }
}

class AnalyticsViewController: UIViewController {

    let viewModel = AnalyticsViewControllerModel()
    
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

    @objc private func changeKind(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print(sender.selectedSegmentIndex)
        default:
            print(sender.selectedSegmentIndex)
        }
    }
    
    private func setupSportclimbingAnalytics() {
        let onsightLevel = CircleButtonWithText(mode: .outlinedLarge, buttonText: viewModel.onsightLevel, labelText: "Onsight Level")
        let performanceTrend = CircleButtonWithText(mode: .outlinedLarge, buttonText: viewModel.performanceTrend, labelText: "Performance Trend")
        
        let stackView01 = UIStackView(arrangedSubviews: [onsightLevel, performanceTrend])
        stackView01.spacing = 0
        stackView01.axis = .horizontal
        view.addSubview(stackView01)
        stackView01.translatesAutoresizingMaskIntoConstraints = false
        stackView01.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView01.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }
}
