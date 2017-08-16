//
//  SessionViewModel.swift
//  VRTCL
//
//  Created by Lindemann on 16.08.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class SessionViewModel {
	
	var session: Session = Session(kind: .sportClimbing)
	var climb: Climb = Climb()
	var kind: Kind { return session.kind }
	
	internal var navigationBarColor: UIColor {
		return kind == .sportClimbing ? Colors.purple : Colors.discoBlue
	}
	
	internal var estimatedDuration: Int {
		guard let date = session.date else { return 0 }
		return Calendar.current.dateComponents([.hour], from: date, to: Date()).hour ?? 0
	}
	
	internal func setSessionToNil() {
		switch kind {
		case .bouldering:
			AppDelegate.shared.boulderingSession = nil
		case .sportClimbing:
			AppDelegate.shared.sportClimbingSession = nil
		}
	}
}
