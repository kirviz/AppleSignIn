//
//  ViewController.swift
//  AppleSignIn
//
//  Created by Darius Jankauskas on 07/07/2020.
//


// Apple example: https://developer.apple.com/documentation/authenticationservices/implementing_user_authentication_with_sign_in_with_apple

import UIKit
import SwiftUI
import AuthenticationServices


class ViewController: UIViewController {
    
    private let appleSigninProvider: AppleSignInProvider
    
    init(appleSigninProvider: AppleSignInProvider) {
        self.appleSigninProvider = appleSigninProvider
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupAppleButton()
    }
    
    func setupAppleButton() {
        let appleButton = appleSigninProvider.appleButton()

        appleButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(appleButton)

        NSLayoutConstraint.activate([
            appleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50.0),
            appleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50.0),
            appleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70.0),
            appleButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        
        appleSigninProvider.onSignIn = { [weak self] _ in
            DispatchQueue.main.async {
                let controller = UIHostingController(rootView: ResultUIView())
                self?.navigationController?.setViewControllers([controller], animated: false)
            }
        }
    }
}
