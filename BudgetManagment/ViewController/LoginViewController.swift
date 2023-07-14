//
//  ViewController.swift
//  BudgetManagment
//
//  Created by Muhammet  on 12.07.2023.
//

import UIKit

final class LoginViewController: UIViewController, LoginViewModelDelegate {
    //MARK: IBOutlets
    private lazy var viewModel = LoginViewModel()
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureTextField(emailTextField, withPlaceholder: "E-mail")
        configureTextField(passwordTextField, withPlaceholder: "Password")
        configureLoginButton()
    }
    //MARK: - IBActions
    @IBAction private func signUpButtonTapped(_ sender: Any) {
        print("signup button tapped")
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        if let signupViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            self.navigationController?.pushViewController(signupViewController, animated: true)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            signupViewController.title = "Sign Up"
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        let user = User(email: email, password: password)
        viewModel.login(user: user)
    }
    //MARK: - Functions
    private func configureTextField(_ textField: UITextField, withPlaceholder placeholder: String) {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        textField.layer.cornerRadius = 15.0
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    private func configureLoginButton(){
        loginButton.layer.cornerRadius = 15.0
    }
    
    func loginSucceeded() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabbarController") as? UITabBarController {
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = tabBarController
                }
            }
        }
    }
    func loginFailed(with error: String) {
        let alert = UIAlertController(title: "Login Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
