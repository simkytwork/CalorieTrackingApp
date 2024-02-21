//
//  AddFoodView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 15/02/2024.
//

import UIKit

class AddFoodView: UIView {
    
    private let stackView = UIStackView()
    
    private let firstFormStackView = UIStackView()
    private let firstFormBackgroundView = UIView()
    private let nameTextField = UITextField()
    private let brandTextField = UITextField()
    private let categoryButton = UIButton(primaryAction: nil)
    
    private let secondStackView = UIStackView()
    private let secondFormStackView = UIStackView()
    private let secondFormBackgroundView = UIView()
    private let servingTypeButton = UIButton(primaryAction: nil)
    private let servingContentButton = UIButton(primaryAction: nil)
    var onServingContentSelected: ((_ selectedContent: String) -> Void)?
    private let additionalServingContentLabel = UILabel()
    private let servingTextField = UITextField()
    
    private let thirdStackView = UIStackView()
    private let thirdFormStackView = UIStackView()
    private let thirdFormBackgroundView = UIView()
    private let kcalTextField = UITextField()
    private let carbsTextField = UITextField()
    private let proteinTextField = UITextField()
    private let fatTextField = UITextField()
    
    private let addButton = UIButton(type: .system)
    var onAddButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupForm()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupForm()
    }
    
    private func setupForm() {
        backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1)
        stackView.axis = .vertical
        stackView.spacing = 10
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
        ])
        
        setupFirstForm()
        addSpacerView(ofHeight: 7)
        setupSecondForm()
        addSpacerView(ofHeight: 7)
        setupThirdForm()
        initializeDropdownMenus()
        addSpacerView(ofHeight: 10)
        setupAddButton()
        addSpacerView(ofHeight: 3)
    }
    
    private func setupFirstForm() {
        stackView.addArrangedSubview(createFormTitleLabel(withText: "Basic information"))
        
        firstFormStackView.axis = .vertical
        firstFormStackView.spacing = 6
        firstFormBackgroundView.addSubview(firstFormStackView)
        
        configureTextField(nameTextField, placeholder: "e.g. Apple, Banana")
        configureTextField(brandTextField, placeholder: "optional")
        
        firstFormStackView.addArrangedSubview(createTextFieldFormEntry(labelText: "Name", textField: nameTextField))
        firstFormStackView.addArrangedSubview(createSeparator())
        firstFormStackView.addArrangedSubview(createTextFieldFormEntry(labelText: "Brand", textField: brandTextField))
        firstFormStackView.addArrangedSubview(createSeparator())
        firstFormStackView.addArrangedSubview(createDropdownMenuFormEntry(labelText: "Category", button: categoryButton))
        
        applyFormBackgroundStyle(to: firstFormBackgroundView)
        stackView.addArrangedSubview(firstFormBackgroundView)
        
        firstFormStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstFormStackView.topAnchor.constraint(equalTo: firstFormBackgroundView.topAnchor, constant: 10),
            firstFormStackView.bottomAnchor.constraint(equalTo: firstFormBackgroundView.bottomAnchor, constant: -10),
            firstFormStackView.leadingAnchor.constraint(equalTo: firstFormBackgroundView.leadingAnchor, constant: 10),
            firstFormStackView.trailingAnchor.constraint(equalTo: firstFormBackgroundView.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupSecondForm() {
        stackView.addArrangedSubview(createFormTitleLabel(withText: "Serving information"))
        
        secondFormStackView.axis = .vertical
        secondFormStackView.spacing = 6
        secondFormBackgroundView.addSubview(secondFormStackView)
        
        configureTextField(servingTextField, placeholder: "-")
        
        let servingEntryView = createTextFieldFormEntry(labelText: "Serving weight", textField: servingTextField)
        servingTextField.keyboardType = .numberPad
        additionalServingContentLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalServingContentLabel.text = " g"
        additionalServingContentLabel.font = UIFont.systemFont(ofSize: 16)
        servingEntryView.addSubview(additionalServingContentLabel)
        if let textFieldConstraint = servingEntryView.constraints.first(where: { constraint in
            constraint.firstItem as? NSObject == servingTextField && constraint.firstAttribute == .trailing
        }) {
            textFieldConstraint.isActive = false
        }
        
        NSLayoutConstraint.activate([
            servingTextField.trailingAnchor.constraint(equalTo: additionalServingContentLabel.leadingAnchor, constant: -8),
            
            additionalServingContentLabel.trailingAnchor.constraint(equalTo: servingEntryView.trailingAnchor),
            additionalServingContentLabel.centerYAnchor.constraint(equalTo: servingTextField.centerYAnchor)
        ])
        
        secondFormStackView.addArrangedSubview(createDropdownMenuFormEntry(labelText: "Serving type", button: servingTypeButton))
        secondFormStackView.addArrangedSubview(createSeparator())
        secondFormStackView.addArrangedSubview(createDropdownMenuFormEntry(labelText: "Serving content", button: servingContentButton))
        secondFormStackView.addArrangedSubview(createSeparator())
        secondFormStackView.addArrangedSubview(servingEntryView)
        
        applyFormBackgroundStyle(to: secondFormBackgroundView)
        stackView.addArrangedSubview(secondFormBackgroundView)
        
        secondFormStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondFormStackView.topAnchor.constraint(equalTo: secondFormBackgroundView.topAnchor, constant: 10),
            secondFormStackView.bottomAnchor.constraint(equalTo: secondFormBackgroundView.bottomAnchor, constant: -10),
            secondFormStackView.leadingAnchor.constraint(equalTo: secondFormBackgroundView.leadingAnchor, constant: 10),
            secondFormStackView.trailingAnchor.constraint(equalTo: secondFormBackgroundView.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupThirdForm() {
        stackView.addArrangedSubview(createFormTitleLabel(withText: "Nutritional information"))
        
        thirdFormStackView.axis = .vertical
        thirdFormStackView.spacing = 6
        thirdFormBackgroundView.addSubview(thirdFormStackView)
        
        configureTextField(kcalTextField, placeholder: "required")
        kcalTextField.keyboardType = .decimalPad
        configureTextField(carbsTextField, placeholder: "required")
        carbsTextField.keyboardType = .decimalPad
        configureTextField(proteinTextField, placeholder: "required")
        proteinTextField.keyboardType = .decimalPad
        configureTextField(fatTextField, placeholder: "required")
        fatTextField.keyboardType = .decimalPad
        
        thirdFormStackView.addArrangedSubview(createTextFieldFormEntry(labelText: "Kcal / 100g", textField: kcalTextField))
        thirdFormStackView.addArrangedSubview(createSeparator())
        thirdFormStackView.addArrangedSubview(createTextFieldFormEntry(labelText: "Carbs / 100g", textField: carbsTextField))
        thirdFormStackView.addArrangedSubview(createSeparator())
        thirdFormStackView.addArrangedSubview(createTextFieldFormEntry(labelText: "Protein / 100g", textField: proteinTextField))
        thirdFormStackView.addArrangedSubview(createSeparator())
        thirdFormStackView.addArrangedSubview(createTextFieldFormEntry(labelText: "Fat / 100g", textField: fatTextField))
        
        applyFormBackgroundStyle(to: thirdFormBackgroundView)
        stackView.addArrangedSubview(thirdFormBackgroundView)
        
        thirdFormStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thirdFormStackView.topAnchor.constraint(equalTo: thirdFormBackgroundView.topAnchor, constant: 10),
            thirdFormStackView.bottomAnchor.constraint(equalTo: thirdFormBackgroundView.bottomAnchor, constant: -10),
            thirdFormStackView.leadingAnchor.constraint(equalTo: thirdFormBackgroundView.leadingAnchor, constant: 10),
            thirdFormStackView.trailingAnchor.constraint(equalTo: thirdFormBackgroundView.trailingAnchor, constant: -10)
        ])
    }
    
    func applyFormBackgroundStyle(to view: UIView) {
        view.layer.cornerRadius = 6
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.borderWidth = 0.5
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
    }
    
    private func addSpacerView(ofHeight height: CGFloat) {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.backgroundColor = .clear
        
        stackView.addArrangedSubview(spacerView)
        
        NSLayoutConstraint.activate([
            spacerView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func createFormTitleLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }
    
    private func configureTextField(_ textField: UITextField, placeholder: String) {
        textField.borderStyle = .none
        textField.placeholder = placeholder
        textField.textAlignment = .right
        textField.backgroundColor = .clear
        textField.returnKeyType = .done
        textField.font = UIFont.systemFont(ofSize: 16)
    }
    
    private func createTextFieldFormEntry(labelText: String, textField: UITextField) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelText
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.topAnchor.constraint(equalTo: view.topAnchor),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textField.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        return view
    }
    
    private func createDropdownMenuFormEntry(labelText: String, button: UIButton) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelText
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .right
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.down")
        config.imagePlacement = .trailing
        config.imagePadding = 6
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 16)
            return outgoing
        }
        button.configuration = config
        
        view.addSubview(label)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            button.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 15),
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .systemGray5
        
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return separator
    }
    
    private func initializeDropdownMenus() {
        categoryButton.setTitle("required", for: .normal)
        categoryButton.tintColor = UIColor.lightGray
        let defaultMenu = UIMenu(title: "", children: [])
        categoryButton.menu = defaultMenu
        categoryButton.showsMenuAsPrimaryAction = true
        
        servingTypeButton.setTitle("Standard serving", for: .normal)
        servingTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: 5)
        servingTypeButton.tintColor = UIColor.black
        servingTypeButton.menu = defaultMenu
        servingTypeButton.showsMenuAsPrimaryAction = true
        
        servingContentButton.setTitle("g", for: .normal)
        servingContentButton.titleLabel?.font = UIFont.systemFont(ofSize: 5)
        servingContentButton.tintColor = UIColor.black
        servingContentButton.menu = defaultMenu
        servingContentButton.showsMenuAsPrimaryAction = true
    }
    
    func configureCategoryMenu(withOptions options: [String]) {
        configureMenu(for: categoryButton, withOptions: options, selectionHandler: { _ in })
    }
    
    func configureServingTypeMenu(withOptions options: [String]) {
        configureMenu(for: servingTypeButton, withOptions: options, selectionHandler: { _ in })
    }
    
    func configureServingContentMenu(withOptions options: [String]) {
        configureMenu(for: servingContentButton, withOptions: options, selectionHandler: { selectedTitle in
            self.onServingContentSelected?(selectedTitle)
        })
    }
    
    private func configureMenu(for button: UIButton, withOptions options: [String], selectionHandler: @escaping (String) -> Void) {
        let actionClosure = { (action: UIAction) in
            button.setTitle(action.title, for: .normal)
            button.tintColor = UIColor.black
            selectionHandler(action.title)
        }
        
        let menuChildren = options.map { option in
            UIAction(title: option, handler: actionClosure)
        }
        
        button.menu = UIMenu(options: .displayInline, children: menuChildren)
    }
    
    func updateAdditionalLabel(withText text: String) {
        additionalServingContentLabel.text = text
    }
    
    private func setupAddButton() {
        addButton.backgroundColor = .systemGreen
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(addButton)
    }
    
    func setTextFieldDelegates(_ delegate: UITextFieldDelegate) {
        nameTextField.delegate = delegate
        brandTextField.delegate = delegate
    }
    
    @objc func addButtonTapped() {
        onAddButtonTapped?()
    }
    
    func collectFoodInput() -> FoodInput {
        return FoodInput(
            name: nameTextField.text,
            brand: brandTextField.text,
            category: categoryButton.currentTitle,
            servingType: servingTypeButton.currentTitle,
            servingContent: servingContentButton.currentTitle,
            serving: servingTextField.text,
            kcal: kcalTextField.text,
            carbs: carbsTextField.text,
            protein: proteinTextField.text,
            fat: fatTextField.text
        )
    }
}
