//
//  SecondTableViewCell.swift
//  BudgetManagment
//
//  Created by Muhammet  on 12.07.2023.
//

import UIKit
import Firebase
class SecondTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
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

