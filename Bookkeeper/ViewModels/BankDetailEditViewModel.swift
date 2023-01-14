import Foundation
import SwiftUI
import RealmSwift

class BankDetailEditViewModel: ObservableObject {
    @Published var name = ""
    @Published var availableBalance = ""
    @Published var monthlyDeposit = ""
    @Published var showingCreditCardList = false
    @Published var selectedCreditCards: [CreditCard] = []
    @Published var showingError = false
    @Published var showingDeleteAlert = false
    var originallySelectedCreditCards: [CreditCard] = []
    let realm = try! Realm()
    
    func isCreditCardSelected(_ id: String) -> Bool {
        return selectedCreditCards.contains(where: { $0.id == id })
    }
    
    func creditCardTaken(_ id: String, _ editingBankId: String) -> Bool {
        return !id.isEmpty && id != editingBankId
    }
    
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
        
        // modify the linked or unlinked credit card models
        var cardsAdded: [CreditCard] = []
        for card in selectedCreditCards {
            if !originallySelectedCreditCards.contains(where: { $0.id == card.id }) {
                cardsAdded.append(card)
            }
        }
        if !cardsAdded.isEmpty {
            modifyLinkedCards(cardsArray: cardsAdded, bankIdToAdd: id)
        }
        
        var cardsRemoved: [CreditCard] = []
        for card in originallySelectedCreditCards {
            if !selectedCreditCards.contains(where: { $0.id == card.id }) {
                cardsRemoved.append(card)
            }
        }
        if !cardsRemoved.isEmpty {
            modifyLinkedCards(cardsArray: cardsRemoved, bankIdToAdd: nil)
        }
        
        // exit the view
        completion(true)
    }
    
    func deleteBank(_ editingBank: Bank?, completion: ((Bool) -> ())) {
        if let editingBank = editingBank {
            try! realm.write {
                realm.delete(realm.objects(BankModel.self).filter("id=%@", editingBank.id))
            }
        }
        
        // modify the linked credit card models
        modifyLinkedCards(cardsArray: originallySelectedCreditCards, bankIdToAdd: nil)
        
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
