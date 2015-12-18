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
        
        let size: CGFloat = 60
        let frame = CGRect(x: view.center.x - 30, y: 200, width: size, height: size)
        let circleButton = CircleButton(frame: frame, text: "5.15C", color: UIColor.redColor(), appearanceMode: .Outlined, interactionMode: .Activated)
        self.view.addSubview(circleButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

