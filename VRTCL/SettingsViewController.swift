//
//  SettingsViewController.swift
//  VRTCL
//
//  Created by Lindemann on 19.09.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit
import Kingfisher

internal struct SettingsViewControllerViewModel {
	
}

class SettingsViewController: UIViewController {
	
	let user = AppDelegate.shared.user
	var viewModel = SettingsViewControllerViewModel()
	var photoButton: PhotoButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = Colors.darkGray
		navigationItem.title = "Settings"
		setup()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setup()
	}
	
	private func setup() {
		view.subviews.forEach({ $0.removeFromSuperview() })
		
		photoButton = PhotoButton(diameter: 130, image: nil)
		photoButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
		
		if let photoURL = AppDelegate.shared.user.photoURL {
			let url = URL(string: photoURL)
			photoButton.kf.setImage(with: url, for: .normal)
		}
		
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
		label.textAlignment = .center
		label.font = Fonts.h3
		label.numberOfLines = 0;
		label.textColor = Colors.lightGray
		label.text = "\(user.name ?? "")\n\(user.email ?? "")"
		label.widthAnchor.constraint(equalToConstant: label.frame.size.width).isActive = true
		
		let logoutButton = FatButton(color: Colors.purple, title: "Logout")
		logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
		
		let stackView = UIStackView(arrangedSubviews: [photoButton, label, logoutButton])
		view.addSubview(stackView)
		stackView.spacing = 30
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		stackView.alignment = .center
	}
	
	@objc private func logout() {
		AppDelegate.shared.user.logout()
		if let tabBarController = tabBarController as? TabBarController {
			tabBarController.showLoginViewControllerIfNeeded()
		}
	}
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@objc private func addPhoto() {
		presentImagePickerView()
	}
	
	private func presentImagePickerView() {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.allowsEditing = false
		picker.sourceType = .photoLibrary
		picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
		present(picker, animated: true, completion: nil)
	}
	
	internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//		// Local variable inserted by Swift 4.2 migrator.
//		let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//		
//		if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
//			
//			if let smallImage = image.scaleImageToSize(newSize: CGSize(width: 300, height: 300)) {
//				
//				//                print(image.size)
//				//                print(smallImage.size)
//				//                let imgData1: Data = UIImageJPEGRepresentation(image, 0)!
//				//                print("Size of Image: \(imgData1.count) bytes")
//				//                let imgData: Data = UIImageJPEGRepresentation(smallImage, 0)!
//				//                print("Size of Image: \(imgData.count) bytes")
//				
//				// Cloudinary
//				if let config = CLDConfiguration(cloudinaryUrl: Keys.cloudinaryURL), let data = smallImage.pngData() as Data? {
//					let cloudinary = CLDCloudinary(configuration: config)
//					UIApplication.shared.isNetworkActivityIndicatorVisible = true
//					cloudinary.createUploader().upload(data: data, uploadPreset: Keys.cloudinaryUploadPreset, params: nil, progress: nil, completionHandler: { (result, error) in
//						if var url = result?.url {
//							url = url.replacingOccurrences(of: "http://", with: "https://") // Could Cloudinary not convince to respond with https url
//							UIApplication.shared.isNetworkActivityIndicatorVisible = true
//							APIController.post(photoURL: url, completion: { (success, error) in
//								if success {
//									UserDefaults().set(url, forKey: "photoURL")
//									AppDelegate.shared.user.photoURL = url
//									self.photoButton.setImage(smallImage, for: .normal)
//								} else {
//									APIController.showAlertFor(reason: "Error while updating photo", In: self)
//								}
//								UIApplication.shared.isNetworkActivityIndicatorVisible = false
//							})
//						}
//						UIApplication.shared.isNetworkActivityIndicatorVisible = false
//					})
//				}
//			}
//			
//		}
		dismiss(animated: true, completion: nil)
	}
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
