//
//  SecondTableViewCell.swift
//  BudgetManagment
//
//  Created by Muhammet  on 12.07.2023.
//

import UIKit
import Firebase
final class SecondTableViewCell: UITableViewCell {
    //MARK: IBOutlet
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    //MARK: Functions
     func configure(with expense: Expense) {
        categoryLabel.text = expense.category
        amountLabel.text = "$\(Int(expense.amount))"
        
        if expense.amount < 0 {
            amountLabel.textColor = .red // veya istediğiniz renk
        } else {
            amountLabel.textColor = .white // veya istediğiniz renk
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dateLabel.text = formatter.string(from: expense.date)
    }
}

