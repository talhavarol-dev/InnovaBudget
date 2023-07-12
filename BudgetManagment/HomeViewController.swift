//
//  HomeViewController.swift
//  BudgetManagment
//
//  Created by Muhammet  on 12.07.2023.
//

import UIKit
import Firebase

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var homeViewModel = HomeViewModel()
    var totalAmount: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FirstTableViewCell", bundle: nil), forCellReuseIdentifier: "FirstCell")
        tableView.register(UINib(nibName: "SecondTableViewCell", bundle: nil), forCellReuseIdentifier: "SecondCell")
        fetchData()
        fetchTotalAmount()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         fetchData()
         self.tableView.reloadData()
         fetchTotalAmount()
    }
    func fetchData() {
        homeViewModel.fetchExpenses { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    func fetchTotalAmount(){
        homeViewModel.getTotalAmount { total in
            DispatchQueue.main.async {
                self.totalAmount = total
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func newİtemButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "NewExpense", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "NewExpenseViewController")
        newViewController.modalPresentationStyle = .fullScreen // Ekranın tamamını kaplaması için
        present(newViewController, animated: true, completion: nil)
        
    }
    @IBAction func addSalaryButtonTapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Salary", message: "Please enter your salary", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Salary"
            textField.keyboardType = .numberPad
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let salaryTextField = alertController.textFields![0] as UITextField
            if let salary = salaryTextField.text {
                UserDefaults.standard.set(salary, forKey: "salary")
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FirstTableViewCell {
                    cell.setSalary(salary)
                }
            }
        })
        alertController.addAction(saveAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.expenseCount + 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath) as! FirstTableViewCell
            cell.karzararLabel.text = "Toplam Kar-Zarar: $\(Int(self.totalAmount))"
            
            if let savedSalary = UserDefaults.standard.string(forKey: "salary") {
                cell.setSalary(savedSalary)
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath) as! SecondTableViewCell
            if let expense = homeViewModel.getExpense(at: indexPath.row - 1) {
                cell.configure(with: expense)
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else{
            return 100
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               if indexPath.row > 0 {
                   let expense = homeViewModel.getExpense(at: indexPath.row - 1)
                   homeViewModel.deleteExpense(documentId: (expense?.documentId)!) { [weak self] result in
                       switch result {
                       case .success:
                           self?.homeViewModel.removeExpense(at: indexPath.row - 1)
                           tableView.deleteRows(at: [indexPath], with: .fade)
                           self?.fetchTotalAmount()
                       case .failure(let error):
                           print("Error deleting document: \(error)")
                       }
                   }
               }
           }
       }
}

