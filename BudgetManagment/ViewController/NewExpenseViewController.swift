//
//  NewExpenseViewController.swift
//  BudgetManagment
//
//  Created by Muhammet  on 12.07.2023.
//

import UIKit

final class NewExpenseViewController: UIViewController {
    //MARK: IBOutlet
    @IBOutlet private weak var ınOrExControl: UISegmentedControl!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var categoriesTextField: UITextField!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var datePicker: UIDatePicker!
    private lazy var expenseViewModel = ExpenseViewModel()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAddButton()
        configureTextField(amountTextField, withPlaceholder: "How Many")
        configureTextField(categoriesTextField, withPlaceholder: "Categories")        // Do any additional
        datePickerConfigure()
    }
    //MARK: IBActions
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let category = categoriesTextField.text,
              let amountString = amountTextField.text,
              let amount = Double(amountString) else {
            return
        }
        
        let selectedDate = datePicker.date
        let isIncome = (ınOrExControl.selectedSegmentIndex == 0) // Gelir segmenti seçiliyse true, aksi halde false
        
        let signedAmount = isIncome ? amount : -amount // Gelir için pozitif, gider için negatif değer
        
        expenseViewModel.addExpense(category: category, amount: signedAmount, date: selectedDate)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func incomeExpenseControlValueChanged(_ sender: Any) {
        
    }
    //MARK: Functions
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
    
    private func datePickerConfigure(){
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Kullanıcı \(formattedDate) tarihini seçti.")
    }
    private func configureAddButton(){
        addButton.layer.cornerRadius = 15.0
    }
    
}
