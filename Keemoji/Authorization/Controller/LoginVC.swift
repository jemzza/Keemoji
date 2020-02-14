//
//  LoginViewController.swift
//  Keemoji
//
//  Created by Alexander on 13.02.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import AuthenticationServices

class LoginVC: UIViewController {
    
    var userProfile: UserProfile?
    private var provider: String?
    
//    lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
//        let loginButton = ASAuthorizationAppleIDButton()
//        loginButton.frame = CGRect(x: 32, y: 360, width: view.frame.width - 64, height: 50)
//        loginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
//        return loginButton
//    }()
    
    lazy var googleLoginButton: GIDSignInButton = {
        
        let loginButton = GIDSignInButton()
        loginButton.frame = CGRect(x: 32, y: 360 + 80, width: view.frame.width - 64, height: 50)
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: .cyan, bottomColor: .red)
        
        setupViews()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    private func setupViews() {
//        view.addSubview(appleLoginButton)
        view.addSubview(googleLoginButton)
    }
    
    private func openMenuListViewController() {
        dismiss(animated: true)
    }
    
//    @objc
//    private func appleLoginButtonTapped() {
//        let request = ASAuthorizationAppleIDProvider().createRequest()
//        request.requestedScopes = [.fullName, .email]
//        let controller = ASAuthorizationController(authorizationRequests: [request])
////        controller.delegate = self as! ASAuthorizationControllerDelegate
////        controller.presentationContextProvider = self as! ASAuthorizationControllerPresentationContextProviding
//        controller.performRequests()
//    }
    
    private func saveIntoFirebase() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userData = ["name": userProfile?.name, "email": userProfile?.email]
        let values = [uid: userData]
        
        Database.database().reference().child("users").updateChildValues(values) { (error, _) in
            
            if let error = error {
                print(error)
                return
            }
            
            print("Successfully saved user into firebase database")
            self.openMenuListViewController()
        }
    }
}


// MARK: Google SDK

extension LoginVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Failed to login with Google: ", error)
            return
        }
        
        print("Successfully logged with Google")
        
        if let userName = user.profile.name, let userEmail = user.profile.email {
            
            let userData = ["name": userName, "email": userEmail]
            userProfile = UserProfile(data: userData)
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if let error = error {
                print("Something went wrong with Google user: ", error)
                return
            }
            
            print("Successfully logged into Firebase with Google")
            self.saveIntoFirebase()
        }
    }
}
