//
//  LoginViewController.swift
//  VRTCL
//
//  Created by Lindemann on 18.09.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

internal struct LoginViewControllerViewModel {
	var email: String?
	var password: String?
}

class LoginViewController: UIViewController {
	
	var viewModel = LoginViewControllerViewModel()
	
	var stackView: UIStackView!
	lazy var centerConstraint = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: self.navigationController?.navigationBar.frame.size.height ?? 0)
	lazy var centerConstraintWithConstant = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = Colors.darkGray
		navigationItem.title = "Login"
		setup()
    }
	
	private func setup() {
		
		let icon = #imageLiteral(resourceName: "icon80x80")
		let iconImageView = UIImageView(image: icon)
		
		let emailTextField = FatTextField(origin: CGPoint.zero)
		emailTextField.placeholder = "Email"
		emailTextField.tag = 0
		emailTextField.delegate = self
		emailTextField.textContentType = .emailAddress
		emailTextField.keyboardType = .emailAddress
		emailTextField.autocapitalizationType = .none
		emailTextField.spellCheckingType = .no
		
		let passwordTextField = FatTextField(origin: CGPoint.zero)
		passwordTextField.placeholder = "Password"
		passwordTextField.tag = 1
		passwordTextField.delegate = self
		passwordTextField.textContentType = .password
		passwordTextField.isSecureTextEntry = true
		passwordTextField.autocapitalizationType = .none
		passwordTextField.spellCheckingType = .no
		
		let loginButton = FatButton(color: Colors.purple, title: "Login")
		loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
		
		let forgotPasswordButton = UIButton(type: .system)
		forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
		forgotPasswordButton.tintColor = Colors.lightGray
		forgotPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
		
		let signupButton = FatButton(color: Colors.lightGray, title: "Sign up", hasArrow: true)
		signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
		
		stackView = UIStackView(arrangedSubviews: [iconImageView, emailTextField, passwordTextField, loginButton, signupButton, forgotPasswordButton])
		view.addSubview(stackView)
		stackView.spacing = 30
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stackView.alignment = .center
		centerConstraint.isActive = true
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
		view.addGestureRecognizer(tapGestureRecognizer)
		
		// Set bigger space between icon and textfiled on iPhone 7/8 plus
		if view.frame.size.height > 700 {
			stackView.setCustomSpacing(60, after: iconImageView)
		}
	}
}

extension LoginViewController: UITextFieldDelegate {
	
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
		if let count = textField.text?.count, count > 0 {
			switch textField.tag {
			case 0:
				viewModel.email = textField.text
			default:
				viewModel.password = textField.text
			}
		} else {
			switch textField.tag {
			case 0:
				viewModel.email = nil
			default:
				viewModel.password = nil
			}
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		view.endEditing(true)
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		slideUp()
	}
}

// MARK: API Stuff
extension LoginViewController {
	@objc private func login() {
		view.endEditing(true)
		guard let password = viewModel.password, let email = viewModel.email else {
			let generator = UIImpactFeedbackGenerator(style: .heavy)
			generator.impactOccurred()
			return
		}
		APIController.login(email: email, password: password) { (success, error, token) in
			if success {
				guard let token = token else { return }
				AppDelegate.shared.user.token = token
				APIController.user(token: token, completion: { (success, error, user) in
					if success {
						guard let name = user?.name else { return }
						guard let email = user?.email else { return }
						guard let id = user?.id else { return }
						let photoURL = user?.photoURL
						let user = AppDelegate.shared.user
						user.saveCrdentials(email: email, password: password, name: name, token: token, photoURL: photoURL, id: id)
						user.updateSessionsWithAPI()
						user.setupFromUserDefaults()
						self.dismiss(animated: true, completion: nil)
					} else {
						APIController.showAlertFor(reason: "Invalid Credentials", In: self)
					}
				})
			} else {
				if error?.statusCode == nil {
					APIController.showAlertFor(reason: "No connection to server", In: self)
				} else {
					APIController.showAlertFor(reason: "Invalid Credentials", In: self)
				}
			}
		}
	}
	
	@objc private func signup() {
		view.endEditing(true)
		let signupViewController = SignupViewController()
		navigationController?.pushViewController(signupViewController, animated: true)
	}
	
	@objc private func forgotPassword() {
		view.endEditing(true)
	}

}












