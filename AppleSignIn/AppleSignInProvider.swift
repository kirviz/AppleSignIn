//
//  AppleSignInProvider.swift
//  AppleSignIn
//
//  Created by Darius Jankauskas on 08/07/2020.
//  Copyright © 2020 The Floow. All rights reserved.
//

import Foundation
import AuthenticationServices

public class AppleSignInProvider: NSObject {
    public static func checkState(signedIn: @escaping ()->(), notSignedIn: @escaping ()->()) {
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            print("\(userID)")
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID, completion: { credentialState, error in

                switch(credentialState){
                case .authorized:
                    print("Already signed in!")
                    signedIn()
                default:
                    print("Not signed in!")
                    notSignedIn()
                }
            })
        }
    }
    
    public static func didAuthorize(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            var identityToken : String?
            if let token = appleIDCredential.identityToken {
                identityToken = String(bytes: token, encoding: .utf8)
            }

            var authorizationCode : String?
            if let code = appleIDCredential.authorizationCode {
                authorizationCode = String(bytes: code, encoding: .utf8)
            }
            
            print("\(appleIDCredential), \(identityToken ?? "no identity token"), \(authorizationCode ?? "no authorization code")")
            
            UserDefaults.standard.set(appleIDCredential.user, forKey: "userID")
            UserDefaults.standard.set(appleIDCredential.fullName?.givenName, forKey: "givenName")
            UserDefaults.standard.set(appleIDCredential.fullName?.familyName, forKey: "familyName")
            UserDefaults.standard.set(appleIDCredential.email, forKey: "email")
        }
    }
    
    private var window: UIWindow?
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func appleButton() {
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
    }
    
    @objc public func appleSignInTapped() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.presentationContextProvider = self
        authController.delegate = self
        
        authController.performRequests()
    }
}

extension AppleSignInProvider : ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window!
    }
}

extension AppleSignInProvider : ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
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
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        AppleSignInProvider.didAuthorize(authorization)
    }
}


        // this is to chek for revokin while the app is running
//        NotificationCenter.default.addObserver(self, selector: #selector(appleIDStateRevoked), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
