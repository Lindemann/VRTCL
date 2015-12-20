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
        
        let size: CGFloat = 60
        let frame = CGRect(x: view.center.x - size / 2 , y: 200, width: size, height: size)
        let circleButton = CircleButton(frame: frame, text: "5.15C", color: UIColor(red:0.8, green:1, blue:0.4, alpha:1), appearanceMode: .Outlined, interactionMode: .Activated)
        self.view.addSubview(circleButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

