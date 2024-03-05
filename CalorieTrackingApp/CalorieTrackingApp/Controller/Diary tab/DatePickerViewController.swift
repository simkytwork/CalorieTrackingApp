//
//  DatePickerViewController.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 28/02/2024.
//

import UIKit

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
