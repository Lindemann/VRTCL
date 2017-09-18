//
//  SignupViewController.swift
//  VRTCL
//
//  Created by Lindemann on 18.09.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

struct SignupViewControllerViewModel {
	var email: String?
	var password: String?
}

class SignupViewController: UIViewController {
	
	var viewModel = LoginViewControllerViewModel()
	
	var stackView: UIStackView!
	lazy var centerConstraint = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
	lazy var centerConstraint120 = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = Colors.darkGray
		navigationController?.title = "Sign up"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
		setup()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	private func setup() {
		let emailTextField = FatTextField(origin: CGPoint.zero)
		emailTextField.placeholder = "Email"
		emailTextField.tag = 0
		emailTextField.delegate = self
		
		let nameTextField = FatTextField(origin: CGPoint.zero)
		nameTextField.placeholder = "User Name"
		nameTextField.tag = 1
		nameTextField.delegate = self
		
		let passwordTextField = FatTextField(origin: CGPoint.zero)
		passwordTextField.placeholder = "Password"
		passwordTextField.tag = 2
		passwordTextField.delegate = self
		
		let signupButton = FatButton(color: Colors.purple, title: "Sign up")
		signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
		
		stackView = UIStackView(arrangedSubviews: [emailTextField, nameTextField, passwordTextField, signupButton])
		view.addSubview(stackView)
		stackView.spacing = 30
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		centerConstraint.isActive = true
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
		view.addGestureRecognizer(tapGestureRecognizer)
	}
	
	@objc private func close() {
		dismiss(animated: true, completion: nil)
	}
	
	@objc private func login() {
		view.endEditing(true)
	}
	
	@objc private func signup() {
		view.endEditing(true)
	}
	
	@objc private func forgottPassword() {
		view.endEditing(true)
	}
}

extension SignupViewController: UITextFieldDelegate {
	
	private func slideUp() {
		UIView.animate(withDuration: 0.4, animations: {
			self.centerConstraint.isActive = false
			self.centerConstraint120.isActive = true
			self.view.layoutIfNeeded()
		})
	}
	
	private func slideDown() {
		UIView.animate(withDuration: 0.4, animations: {
			self.centerConstraint.isActive = true
			self.centerConstraint120.isActive = false
			self.view.layoutIfNeeded()
		})
	}
	
	@objc func tap() {
		view.endEditing(true)
		slideDown()
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if let count = textField.text?.characters.count, count > 0 {
			switch textField.tag {
			case 0:
				viewModel.email = textField.text
			default:
				viewModel.password = textField.text
			}
		}
		slideDown()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		view.endEditing(true)
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField.tag != 0 {
			slideUp()
		}
	}
}

