import Foundation
import SwiftUI
import RealmSwift

class BankDetailEditViewModel: ObservableObject {
    @Published var name = ""
    @Published var availableBalance = ""
    @Published var monthlyDeposit = ""
    @Published var showingCreditCardList = false
    @Published var availableCreditCards: [CreditCard] = []
    @Published var selectedCreditCards: [CreditCard] = []
    @Published var showingError = false
    @Published var showingDeleteAlert = false
    
    func saveChanges(_ editingBank: Bank?, completion: ((Bool) -> ())) {
        // check for invalid input
        let availableBalanceInt = Int(availableBalance)
        let monthlyDepositInt = Int(monthlyDeposit)
        if name.isEmpty || availableBalanceInt == nil || availableBalanceInt! < 0 || monthlyDepositInt == nil || monthlyDepositInt! < 0 {
            showingError = true
            completion(false)
            return
        }
        
        // get the id and delete the bank we're currently editing
        let realm = try! Realm()
        var id = ""
        if let editingBank = editingBank {
            id = editingBank.id
            try! realm.write {
                realm.delete(realm.objects(BankModel.self).filter("id=%@", editingBank.id))
            }
        } else {
            id = UUID().uuidString
        }
        
        // save the changes as a new bank model
        let newBank = Bank(id: id, name: name, availableBalance: availableBalanceInt!, monthlyDeposit: monthlyDepositInt!, linkedCreditCardIds: selectedCreditCards.map({ $0.id }), recentTransactionIds: editingBank?.recentTransactionIds ?? [])
        let newDBObj = BankModel(bank: newBank)
        try! realm.write {
            realm.add(newDBObj)
        }
        
        // exit the view
        completion(true)
    }
    
    func deleteBank(_ editingBank: Bank?, completion: ((Bool) -> ())) {
        let realm = try! Realm()
        if let editingBank = editingBank {
            try! realm.write {
                realm.delete(realm.objects(BankModel.self).filter("id=%@", editingBank.id))
            }
        }
        
        // exit the view
        completion(true)
    }
}
