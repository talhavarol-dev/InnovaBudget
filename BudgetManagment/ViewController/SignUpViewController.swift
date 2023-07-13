//
//  SignUpViewController.swift
//  BudgetManagment
//
//  Created by Muhammet  on 12.07.2023.
//

import UIKit

final class SignUpViewController: UIViewController, SignUpViewModelDelegate {
    //MARK: - IBOutlets and Properties
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    private lazy var viewModel = SignUpViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField(emailTextField, withPlaceholder: "E-mail")
        configureTextField(passwordTextField, withPlaceholder: "Password")
        configureLoginButton()
        viewModel.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    //MARK: - IBActions
    @IBAction private func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        let user = User(email: email, password: password)
        viewModel.signUp(user: user)
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
        signUpButton.layer.cornerRadius = 15.0
    }
    
    func signUpSucceeded() {
        let alert = UIAlertController(title: "Success", message: "Signed up successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    let navigationController = UINavigationController(rootViewController: loginViewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self?.present(navigationController, animated: true, completion: nil)
                }}}))
        self.present(alert, animated: true, completion: nil)
    }
    func signUpFailed(with error: String) {
        let alert = UIAlertController(title: "HATA", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
    //MARK: -Extensions
extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.textContentType = .oneTimeCode
        return true
    }
}
