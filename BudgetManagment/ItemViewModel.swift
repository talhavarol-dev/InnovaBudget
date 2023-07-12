//
//  ItemViewModel.swift
//  BudgetManagment
//
//  Created by Muhammet  on 12.07.2023.
//


import Foundation
import FirebaseFirestore
import Firebase

class ItemViewModel {
    private let db = Firestore.firestore()
    private var expenses: [Expense] = []
    
    var expenseCount: Int {
        return expenses.count
    }
    
    func addExpense(category: String, amount: Double, date: Date) {
        let data: [String: Any] = [
            "category": category,
            "amount": amount,
            "date": date
        ]
        
        db.collection("expenses").addDocument(data: data) { error in
            if let error = error {
                print("Veri kaydedilirken hata oluştu: \(error)")
            } else {
                print("Veri başarıyla kaydedildi.")
            }
        }
    }
}

