//
//  ViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 13/02/2024.
//

import UIKit
import CoreData

class DiaryViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    let contentView = DiaryView()
    let datePickerVC = DatePickerViewController()
    private var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1)
        self.title = "Diary"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground() // This makes the background transparent
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // Adjust text color as needed
//        
//        // Set the created appearance for large titles
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance // For scrolled or compact state
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setupContentView()
        configureViewActions()
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
    
    private func configureViewActions() {
        contentView.onDateLabelTapped = { [weak self] in
            self?.presentDatePicker()
        }
        
        contentView.onIncrementDateTapped = { [weak self] in
            self?.incrementDate()
        }
        
        contentView.onDecrementDateTapped = { [weak self] in
            self?.decrementDate()
        }
        
        contentView.mealBarTapped = { [weak self] mealName in
            guard let self = self, let meal = self.fetchOrCreateMeal(name: mealName, date: self.selectedDate) else { return }
            let mealViewController = MealViewController(meal: meal)
            self.navigationController?.pushViewController(mealViewController, animated: true)
        }
    }
    
    private func fetchOrCreateMeal(name mealName: String, date: Date) -> Meal? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let dateOnly = calendar.date(from: components) else { return nil }
        
        fetchRequest.predicate = NSPredicate(format: "type == %@ AND date == %@", mealName, dateOnly as NSDate)
        fetchRequest.fetchLimit = 1
        
        do {
            if let existingMeal = try managedContext.fetch(fetchRequest).first {
                return existingMeal
            } else {
                let newMeal = Meal(context: managedContext)
                newMeal.type = mealName
                newMeal.date = dateOnly
                
                try managedContext.save()
                return newMeal
            }
        } catch let error as NSError {
            print("Could not fetch or create a new meal: \(error), \(error.userInfo)")
            return nil
        }
    }
    
    @objc func presentDatePicker() {
        datePickerVC.modalPresentationStyle = .popover
        datePickerVC.preferredContentSize = CGSize(width: 320, height: 400)
        datePickerVC.popoverPresentationController?.sourceView = contentView.popoverSourceView()
        datePickerVC.popoverPresentationController?.sourceRect = contentView.popoverSourceRect()
        datePickerVC.popoverPresentationController?.permittedArrowDirections = .any
        datePickerVC.popoverPresentationController?.delegate = self
        
        datePickerVC.dateSelected = { [weak self] selectedDate in
            self?.contentView.updateDateLabel(with: selectedDate)
            self?.contentView.updateDayNameLabel(with: selectedDate)
            self?.selectedDate = selectedDate
            self?.dismiss(animated: true, completion: nil)
        }
        
        // without checking if it's already being presented, sometimes the app crashes because it tries to present it modally as well
        if self.presentedViewController == nil {
            datePickerVC.updateDatePickerDate(with: selectedDate)
            present(datePickerVC, animated: true, completion: nil)
        }
    }
    
    @objc private func decrementDate() {
        let currentDate = selectedDate
        let newDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        contentView.updateDateLabel(with: newDate)
        contentView.updateDayNameLabel(with: newDate)
        selectedDate = newDate
    }

    @objc private func incrementDate() {
        let currentDate = selectedDate
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        contentView.updateDateLabel(with: newDate)
        contentView.updateDayNameLabel(with: newDate)
        selectedDate = newDate
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

class DatePickerViewController: UIViewController {
    private var datePicker = UIDatePicker()
    var dateSelected: ((Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
    }

    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.tintColor = .systemOrange
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        dateSelected?(sender.date)
    }
    
    func updateDatePickerDate(with newDate: Date) {
        self.datePicker.date = newDate
    }
}

