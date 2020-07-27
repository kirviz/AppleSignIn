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
    
    /// Check signin status using local storage
    public static func checkAuthorisationState(signedIn: @escaping ()->(), notSignedIn: @escaping ()->()) {
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID, completion: { credentialState, error in
                switch(credentialState){
                case .authorized:
                    signedIn()
                default:
                    notSignedIn()
                }
            })
        }
    }
    
    /// Write results to local storage
    public static func saveAuthorisationState(_ authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        UserDefaults.standard.set(appleIDCredential.user, forKey: "userID")
        UserDefaults.standard.set(appleIDCredential.fullName?.givenName, forKey: "givenName")
        UserDefaults.standard.set(appleIDCredential.fullName?.familyName, forKey: "familyName")
        UserDefaults.standard.set(appleIDCredential.email, forKey: "email")
        

        var identityToken : String?
        if let token = appleIDCredential.identityToken {
            identityToken = String(bytes: token, encoding: .utf8)
        }
        
        var authorizationCode : String?
        if let code = appleIDCredential.authorizationCode {
            authorizationCode = String(bytes: code, encoding: .utf8)
        }
        
        print("credential: \(appleIDCredential)\n identity token: \(identityToken ?? "-")\n authorization code: \(authorizationCode ?? "-")")
    }
    
    private let window: UIWindow
    var onSignIn: ((ASAuthorization)->())?
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func appleButton() -> UIControl {
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
        return appleButton
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
        return window
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
        AppleSignInProvider.saveAuthorisationState(authorization)
        onSignIn?(authorization)
    }
}


    // this is to chek if user revokes AppleSIgnIn while the app is running
//        NotificationCenter.default.addObserver(self, selector: #selector(appleIDStateRevoked), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
