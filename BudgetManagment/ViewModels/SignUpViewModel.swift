//
//  SignUpViewModel.swift
//  BudgetManagment
//
//  Created by Muhammet  on 12.07.2023.
//

import Foundation
import FirebaseAuth

protocol SignUpViewModelDelegate: AnyObject {
    func signUpSucceeded()
    func signUpFailed(with error: String)
}

class SignUpViewModel {
    weak var delegate: SignUpViewModelDelegate?
    
    func signUp(user: User) {
        Auth.auth().createUser(withEmail: user.email, password: user.password) { [weak self] authResult, error in
            if let error = error {
                let authError = error as NSError
                switch authError.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    self?.delegate?.signUpFailed(with: "Bu e-posta zaten kullanılıyor")
                case AuthErrorCode.invalidEmail.rawValue:
                    self?.delegate?.signUpFailed(with: "Geçersiz e-posta")
                case AuthErrorCode.weakPassword.rawValue:
                    self?.delegate?.signUpFailed(with: "Zayıf parola")
                default:
                    self?.delegate?.signUpFailed(with: "Bilinmeyen hata: \(authError.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    self?.delegate?.signUpSucceeded()
                }
            }
        }
    }
}
