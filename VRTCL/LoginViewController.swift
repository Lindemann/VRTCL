//
//  LoginViewController.swift
//  VRTCL
//
//  Created by Lindemann on 18.09.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = Colors.darkGray
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
		setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@objc private func close() {
		dismiss(animated: true, completion: nil)
	}
	
	private func setup() {
		let emailTextField = FatTextField(origin: CGPoint.zero)
		emailTextField.placeholder = "Email"
		
		let passwordTextField = FatTextField(origin: CGPoint.zero)
		passwordTextField.placeholder = "Password"
		
		let loginButton = FatButton(color: Colors.purple, title: "Login")
		
		let forgottPasswordButton = UIButton(type: .system)
		forgottPasswordButton.setTitle("Forgott Password?", for: .normal)
		forgottPasswordButton.tintColor = Colors.lightGray
		
		let signupButton = FatButton(color: Colors.purple, title: "Sign up", hasArrow: true)
		
		
		let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgottPasswordButton, signupButton])
		view.addSubview(stackView)
		stackView.spacing = 30
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}

}

extension LoginViewController: UITextFieldDelegate {
	
}
