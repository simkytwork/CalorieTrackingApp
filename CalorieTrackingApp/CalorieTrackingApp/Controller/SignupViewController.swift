//
//  SignupViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 05/03/2024.
//

import UIKit

class SignupViewController: UIViewController {
    private let contentView = SignupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1)
        
        self.title = "Sign Up"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupContentView()
        contentView.setTextFieldDelegates(self)
        
        contentView.onSignupButtonTapped = { [weak self] email, username, password, confirmPassword in
            self?.processSignup(email: email, username: username, password: password, confirmPassword: confirmPassword)
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
    
    private func processSignup(email: String, username: String, password: String, confirmPassword: String) {
        if isValid(email, username, password, confirmPassword) {
            AuthManager.shared.register(email: email, username: username, password: password, completion: { [weak self] in
                let alert = UIAlertController(title: "Sign up successful!", message: "You can now sign in.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self?.navigationController?.popViewController(animated: true)
                }))
                self?.present(alert, animated: true)
            }, onFailure: { [weak self] error in
                self?.presentAlert(with: error)
            })
        } else {
            presentAlert(with: "Please make sure all fields are correctly filled and passwords match.")
        }
    }
    
    private func isNotEmpty(input: String) -> Bool {
        return !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func isValid(_ email: String, _ username: String, _ password: String, _ confirmPassword: String) -> Bool {
        let nonEmptyFields = [email, username, password, confirmPassword]
        
        return nonEmptyFields.allSatisfy(isNotEmpty) && password == confirmPassword
    }
    
    private func presentAlert(with message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

extension SignupViewController: UITextFieldDelegate {
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
