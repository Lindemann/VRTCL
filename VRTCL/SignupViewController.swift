//
//  SignupViewController.swift
//  VRTCL
//
//  Created by Lindemann on 18.09.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

internal struct SignupViewControllerViewModel {
	var email: String?
	var password: String?
	var name: String?
	
	func isValidEmail(testStr:String) -> Bool {
		// print("validate calendar: \(testStr)")
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: testStr)
	}
}

class SignupViewController: UIViewController {
	
	var viewModel = SignupViewControllerViewModel()
	
	var stackView: UIStackView!
	lazy var centerConstraint = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
	lazy var centerConstraintWithConstant = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = Colors.darkGray
		navigationItem.title = "Sign up"
		setup()
	}

	private func setup() {
		let emailTextField = FatTextField(origin: CGPoint.zero)
		emailTextField.placeholder = "Email"
		emailTextField.tag = 0
		emailTextField.delegate = self
		emailTextField.textContentType = .emailAddress
		emailTextField.keyboardType = .emailAddress
		emailTextField.autocapitalizationType = .none
		emailTextField.spellCheckingType = .no
		
		let nameTextField = FatTextField(origin: CGPoint.zero)
		nameTextField.placeholder = "User Name"
		nameTextField.tag = 1
		nameTextField.delegate = self
		nameTextField.textContentType = .name
		nameTextField.spellCheckingType = .no
		
		let passwordTextField = FatTextField(origin: CGPoint.zero)
		passwordTextField.placeholder = "Password"
		passwordTextField.tag = 2
		passwordTextField.delegate = self
		passwordTextField.isSecureTextEntry = true
		passwordTextField.autocapitalizationType = .none
		passwordTextField.spellCheckingType = .no
		
		let signupButton = FatButton(color: Colors.purple, title: "Sign up")
		signupButton.addTarget(self, action: #selector(signup(sender:)), for: .touchUpInside)
		
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
}

extension SignupViewController: UITextFieldDelegate {
	
	private func slideUp() {
		UIView.animate(withDuration: 0.4, animations: {
			self.centerConstraint.isActive = false
			self.centerConstraintWithConstant.isActive = true
			self.view.layoutIfNeeded()
		})
	}
	
	private func slideDown() {
		UIView.animate(withDuration: 0.4, animations: {
			self.centerConstraint.isActive = true
			self.centerConstraintWithConstant.isActive = false
			self.view.layoutIfNeeded()
		})
	}
	
	@objc func tap() {
		view.endEditing(true)
		slideDown()
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		slideDown()
		if let count = textField.text?.characters.count, count > 0 {
			switch textField.tag {
			case 0:
				viewModel.email = textField.text
			case 1:
				viewModel.name = textField.text
			case 2:
				viewModel.password = textField.text
			default:
				break
			}
		} else {
			switch textField.tag {
			case 0:
				viewModel.email = nil
			case 1:
				viewModel.name = nil
			case 2:
				viewModel.password = nil
			default:
				break
			}
		}
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

// MARK: API Stuff
extension SignupViewController {
	@objc private func signup(sender: UIButton) {
		view.endEditing(true)
		guard let password = viewModel.password, let name = viewModel.name, let email = viewModel.email else {
			let generator = UIImpactFeedbackGenerator(style: .heavy)
			generator.impactOccurred()
			return
		}
		if !viewModel.isValidEmail(testStr: email) {
			APIController.showAlertFor(reason: "Invalid Email Adress", In: self)
			return
		}
		// Needed to prevent puhing the signup button several times, which leads to
		// "A user with that email already exists" error
		sender.isUserInteractionEnabled = false
		APIController.signup(email: email, name: name, password: password) { (success, error, user) in
			if success {
				guard let name = user?.name, let email = user?.email else { return }
				APIController.login(email: email, password: password, completion: { (success, error, token) in
					if success {
						guard let token = token else { return }
						guard let id = user?.id else { return }
						AppDelegate.shared.user.saveCrdentials(email: email, password: password, name: name, token: token, photoURL: nil, id: id)
						AppDelegate.shared.user.setupFromUserDefaults()
						self.dismiss(animated: true, completion: nil)
					} else {
						APIController.showAlertFor(reason: "A problem occurred while login", In: self)
					}
				})
				sender.isUserInteractionEnabled = true
			} else {
				sender.isUserInteractionEnabled = true
				if error?.statusCode == nil {
					APIController.showAlertFor(reason: "No connection to server", In: self)
				} else {
					APIController.showAlertFor(reason: "A user with that email already exists", In: self)
				}
			}
		}
	}
}













