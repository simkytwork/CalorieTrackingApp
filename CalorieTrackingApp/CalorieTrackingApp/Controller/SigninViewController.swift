//
//  LoginViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 05/03/2024.
//

import UIKit

class SigninViewController: UIViewController {
    private let contentView = SigninView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundColor
        
        self.title = "Account"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupContentView()
        contentView.setTextFieldDelegates(self)
        
        contentView.onSignupTapped = { [weak self] in
            self?.navigateToSignupView()
        }
        
        contentView.onSigninButtonTapped = { [weak self] username, password in
            self?.processSignin(username: username, password: password)
        }
        
        let isLoggedIn = AuthManager.shared.isLoggedIn()
        let username = isLoggedIn ? AuthManager.shared.currentUsername() : nil
        contentView.updateUIForLoggedInUser(username: username, isLoggedIn: isLoggedIn)
        
        contentView.onSignoutTapped = { [weak self] in
            let alert = UIAlertController(title: "Sign out succesful!", message: "You are no longer logged in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            self?.present(alert, animated: true)
            AuthManager.shared.logout()
            self?.contentView.updateUIForLoggedInUser(isLoggedIn: false)
        }
    }
    
    private func setupContentView() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func processSignin(username: String, password: String) {
        if isValid(username, password) {
            AuthManager.shared.login(username: username, password: password, completion: { [weak self] in
                let alert = UIAlertController(title: "Sign in succesful!", message: "You are now logged in.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self?.navigationController?.popViewController(animated: true)
                }))
                self?.present(alert, animated: true)
            }, onFailure: { [weak self] error in
                self?.presentAlert(with: error)
            })
        } else {
            presentAlert(with: "Please make sure all fields are filled in.")
        }
    }
    
    private func isNotEmpty(input: String) -> Bool {
        return !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func isValid(_ username: String, _ password: String) -> Bool {
        let nonEmptyFields = [username, password]
        
        return nonEmptyFields.allSatisfy(isNotEmpty)
    }
    
    private func presentAlert(with message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    private func navigateToSignupView() {
        let signupVC = SignupViewController()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
}

extension SigninViewController: UITextFieldDelegate {
    @objc private func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
