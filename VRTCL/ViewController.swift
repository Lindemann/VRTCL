//
//  FirstViewController.swift
//  VRTCL
//
//  Created by Lindemann on 11/05/15.
//  Copyright (c) 2015 Lindemann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = ColorConstants.DarkGray
        let center = CGPoint(x: view.center.x , y: 200)
        let circleButton = CircleButton(center: center, diameter: 60, text: "5.15C", color: UIColor(red:0.8, green:1, blue:0.4, alpha:1))
        self.view.addSubview(circleButton)
    }
}

