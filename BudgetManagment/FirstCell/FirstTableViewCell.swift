//
//  FirstTableViewCell.swift
//  BudgetManagment
//
//  Created by Muhammet  on 12.07.2023.
//

import UIKit

class FirstTableViewCell: UITableViewCell {

    @IBOutlet weak var customimageView: UIImageView! = nil
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var karzararLabel: UILabel!
    
    func setSalary(_ salary: String) {
        amountLabel.text = "Total Salary: $\(salary)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
