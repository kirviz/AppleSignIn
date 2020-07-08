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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppleButton()
    }
    
    func setupAppleButton() {
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(appleButton)

        NSLayoutConstraint.activate([
            appleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50.0),
            appleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50.0),
            appleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70.0),
            appleButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])

        appleButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
    }

    @objc func appleSignInTapped() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.presentationContextProvider = self
        authController.delegate = self
        
        authController.performRequests()
    }
}

extension ViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension ViewController : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard let error = error as? ASAuthorizationError else {
            print("non ASAuthorizationError")
            return
        }

        switch error.code {
        case .canceled:
            print("ASAuthorizationError - Canceled")
        case .unknown:
            print("ASAuthorizationError - Unknown")
        case .invalidResponse:
            print("ASAuthorizationError - Invalid Respone")
        case .notHandled:
            print("ASAuthorizationError - Not handled")
        case .failed:
            print("ASAuthorizationError - Failed")
        @unknown default:
            print("ASAuthorizationError - Default")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        AppleSignInProvider.didAuthorize(authorization)
    }
}
