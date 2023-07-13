//
//  AuthViewModel.swift
//  BudgetManagment
//
//  Created by Muhammet  on 12.07.2023.
//

import Foundation
import FirebaseAuth

protocol LoginViewModelDelegate: AnyObject {
    func loginSucceeded()
    func loginFailed(with error: String)
}

final class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?
    
    func login(user: User) {
         Auth.auth().signIn(withEmail: user.email, password: user.password) { [weak self] authResult, error in
             if let error = error {
                 let authError = error as NSError
                 switch authError.code {
                 case AuthErrorCode.wrongPassword.rawValue:
                     self?.delegate?.loginFailed(with: "Yanlış parola")
                 case AuthErrorCode.invalidEmail.rawValue:
                     self?.delegate?.loginFailed(with: "Geçersiz e-posta")
                 case AuthErrorCode.userNotFound.rawValue:
                     self?.delegate?.loginFailed(with: "Bu kullanıcı bulunamadı")
                 default:
                     self?.delegate?.loginFailed(with: "Bilinmeyen hata: \(authError.localizedDescription)")
                 }
             } else {
                 DispatchQueue.main.async {
                     self?.delegate?.loginSucceeded()
                 }
             }
         }
     }
}

