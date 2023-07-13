//
//  HomeViewModel.swift
//  BudgetManagment
//
//  Created by Muhammet  on 12.07.2023.
//
import Foundation
import Firebase

final class HomeViewModel {
    private let db = Firestore.firestore()
    private var expenses: [Expense] = []
    
     var expenseCount: Int {
        return expenses.count
    }
    func fetchExpenses(completion: @escaping () -> Void) {
        db.collection("expenses").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var fetchedExpenses: [Expense] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let category = data["category"] as? String,
                       let amount = data["amount"] as? Double,
                       let date = data["date"] as? Timestamp {
                        let expense = Expense(category: category, amount: amount, date: date.dateValue(), documentId: document.documentID) // documentId added
                        fetchedExpenses.append(expense)
                    }}
                self.expenses = fetchedExpenses
                completion()
            }}
    }
    
    func getExpense(at index: Int) -> Expense? {
        guard index >= 0, index < expenses.count else { return nil }
        return expenses[index]
        
    }
    
    func deleteExpense(documentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("expenses").document(documentId).delete() { err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getTotalAmount(completion: @escaping (Double) -> Void) {
        let expensesRef = db.collection("expenses")
        expensesRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Veri alırken hata oluştu: \(error)")
                completion(0.0)
            } else {
                var totalAmount = 0.0
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let amount = data["amount"] as? Double {
                        totalAmount += amount
                    }
                }
                completion(totalAmount)
            }
        }
    }
    
    func removeExpense(at index: Int) {
        expenses.remove(at: index)
    }
}


