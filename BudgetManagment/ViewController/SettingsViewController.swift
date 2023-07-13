//
//  SettingsViewController.swift
//  BudgetManagment
//
//  Created by Muhammet  on 13.07.2023.
//

import UIKit
import FirebaseAuth

final class SettingsViewController: UIViewController {
    //MARK: IBOutlet
    @IBOutlet private weak var signOutButton: UIButton!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoginButton()
    }
    //MARK: IBActions
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                if let tabBarController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        sceneDelegate.window?.rootViewController = tabBarController
                    }
                }
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    //MARK: Functions
    private func configureLoginButton(){
        signOutButton.layer.cornerRadius = 15.0
    }
}
