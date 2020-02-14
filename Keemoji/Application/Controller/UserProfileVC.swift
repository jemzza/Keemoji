//
//  LogOutViewController.swift
//  Keemoji
//
//  Created by Alexander on 12.02.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class UserProfileVC: UIViewController {
    
    private var provider: String?
    private var currentUser: CurrentUser?
    
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfoLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchingUserData()
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "Log out", message: "Are you sure you want to log out", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.openLoginVC()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(ok)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}

extension UserProfileVC {
    
    private func openLoginVC() {
        
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginVC
                loginViewController.modalPresentationStyle = .fullScreen
                self.present(loginViewController, animated: true, completion: nil)
                return
            }
            
        } catch let error {
            print("Failed to sign out with error: ", error.localizedDescription)
        }
    }
    
    private func fetchingUserData() {
        
        if Auth.auth().currentUser != nil {
            
            if let userName = Auth.auth().currentUser?.displayName {
                activityIndicator.stopAnimating()
                userInfoLabel.isHidden = false
                userInfoLabel.text = getProviderData(with: userName)
            } else {
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                Database.database().reference()
                    .child("users")
                    .child(uid)
                    .observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        guard let userData = snapshot.value as? [String: Any] else { return }
                        
                        self.currentUser = CurrentUser(uid: uid, data: userData)
                        
                        self.activityIndicator.stopAnimating()
                        self.userInfoLabel.isHidden = false
                        self.userInfoLabel.text = self.getProviderData(with: self.currentUser?.name ?? "Unknown")
                        
                    }) { (error) in
                        print(error)
                }
            }
        }
    }
    
    private func getProviderData(with user: String) -> String {
        
        var greetings = ""
        
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "google.com":
                    provider = "google"
                default:
                    provider = "unknown"
                }
            }
            greetings = "\(user) logged in with \(provider!)"
        }
        return greetings
    }
}
