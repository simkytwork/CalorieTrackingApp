//
//  AddFoodViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 15/02/2024.
//

import UIKit
import CoreData

class AddFoodViewController: UIViewController, UITextFieldDelegate {
    private let scrollView = UIScrollView()
    private var contentView = AddFoodView()
    
    private let categoryOptions = ["Test1", "Test2", "Test3", "Test4", "Test5"]
    private let servingTypeOptions = ["Small serving", "Standard serving", "Large serving"]
    private let servingContentOptions = ["g", "mL"]
    
    private var moc: NSManagedObjectContext?
    
    override func loadView() {
        super.loadView()
    
        scrollView.backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.subviews.last!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "Create Food"
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            moc = appDelegate.persistentContainer.viewContext
        }

        // for keyboard dismissal
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeView))
        
        contentView.setTextFieldDelegates(self)
        
        contentView.configureCategoryMenu(withOptions: categoryOptions)
        contentView.configureServingTypeMenu(withOptions: servingTypeOptions)
        contentView.configureServingContentMenu(withOptions: servingContentOptions)
        contentView.onServingContentSelected = { [weak self] selectedContent in
            self?.contentView.updateAdditionalLabel(withText: " \(selectedContent)")
        }
        
        contentView.onAddButtonTapped = { [weak self] in
            self?.performAddAction()
        }
    }
    
    private func performAddAction() {
        let foodInput = contentView.collectFoodInput()
        if validateFoodInput(foodInput) {
            addFood(foodInput)
            closeView()
        } else {
            showAlert(message: "Please fill out the required information correctly!")
        }
    }
    
    private func validateFoodInput(_ input: FoodInput) -> Bool {
        guard input.category != "required" else { return false }
        
        guard let name = input.name, isNotEmpty(name),
              let serving = input.serving, isNotEmpty(serving) else { return false }
        
        let numericValidations = [input.kcal, input.protein, input.carbs, input.fat].compactMap { $0 }.allSatisfy { isValidNum($0) && isNotEmpty($0) }
        
        let servingSizeValid = isValidSize(serving)
        
        return numericValidations && servingSizeValid
    }
    
    private func isNotEmpty(_ input: String) -> Bool {
        return !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // to interpret doubles depending on the locale (for example - 10,2 or 10.2)
    private func localeDouble(from string: String?) -> Double? {
        guard let string = string else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue
    }
    
    private func isValidNum(_ input: String?) -> Bool {
        return localeDouble(from: input).map { $0 >= 0 } ?? false
    }
    
    private func isValidSize(_ input: String?) -> Bool {
        guard let number = localeDouble(from: input) else {
            return false
        }
        return floor(number) == number && number > 0
    }
    
    private func getValuePer(input: String?, size: String?) -> Double {
        guard let inputValue = localeDouble(from: input), let sizeValue = localeDouble(from: size) else {
            return 0.0
        }
        return (inputValue * sizeValue) / 100
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid data", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    private func addFood(_ input: FoodInput) {
        guard let context = moc else {
            print("Managed Object Context is nil")
            return
        }
        
        let food = Food(context: context)
        food.id = UUID()
        food.name = input.name
        food.category = input.category
        
        if input.brand == "" {
            food.brand = nil
        } else {
            food.brand = input.brand
        }
        
        food.serving = input.servingType
        food.perserving = input.servingContent
        
        food.size = localeDouble(from: input.serving) ?? 0.0
        food.kcal = round(getValuePer(input: input.kcal, size: input.serving))
        food.protein = getValuePer(input: input.protein, size: input.serving)
        food.carbs = getValuePer(input: input.carbs, size: input.serving)
        food.fat = getValuePer(input: input.fat, size: input.serving)
        
        do {
            try context.save()
        } catch {
            print("Failed to save food: \(error)")
        }
    }
}
