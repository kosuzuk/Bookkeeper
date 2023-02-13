import Foundation
import SwiftUI
import RealmSwift

class BankDetailEditViewModel: ObservableObject {
    @Published var name = ""
    @Published var currency = Currency.yen
    @Published var availableBalance = ""
    @Published var monthlyDeposit = ""
    @Published var linkedCreditCards: [CreditCard] = []
    @Published var showingError = false
    @Published var showingDeleteAlert = false
    let realm = try! Realm()
    
    func saveChanges(_ editingBank: Bank?, completion: ((Bool) -> ())) {
        // check for invalid input
        if name.isEmpty {
            showingError = true
            completion(false)
            return
        }
        
        // get the id and delete the bank we're currently editing
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
        let newBank = Bank(id: id, name: name, currency: currency, availableBalance: Double(availableBalance)!, monthlyDeposit: Double(monthlyDeposit)!, linkedCreditCardIds: linkedCreditCards.map({ $0.id }), recentTransactionIds: editingBank?.recentTransactionIds ?? [])
        let newDBObj = BankModel(bank: newBank)
        try! realm.write {
            realm.add(newDBObj)
        }
        
        // exit the view
        completion(true)
        
        NotificationCenter.default.post(name: Notification.Name("bankInfoChanged"), object: nil)
    }
    
    func deleteBank(_ editingBank: Bank?, completion: ((Bool) -> ())) {
        if let editingBank = editingBank {
            try! realm.write {
                realm.delete(realm.objects(BankModel.self).filter("id=%@", editingBank.id))
            }
        }
        
        // modify the linked credit card models
        if !linkedCreditCards.isEmpty {
            modifyLinkedCards(cardsArray: linkedCreditCards, bankIdToAdd: nil)
        }
        
        // exit the view
        completion(true)
    }
    
    func modifyLinkedCards(cardsArray: [CreditCard], bankIdToAdd: String?) {
        let cardObjs = realm.objects(CreditCardModel.self)
        for card in cardsArray {
            let filterRes = cardObjs.where {
                $0.id == card.id
            }
            let cardToModify = filterRes[0]
            try! realm.write {
                cardToModify.linkedBankId = bankIdToAdd
            }
        }
    }
}
