//
//  APIController.swift
//  VRTCL
//
//  Created by Lindemann on 18.09.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import Foundation
import Alamofire

struct APIController {
	
	let user = AppDelegate.shared.user
	var authorizationHeader: HTTPHeaders { return ["Authorization": "Basic \(user.token ?? "")"] }
}
