import Foundation
import SwiftUI
import RealmSwift

class CreditCardDetailEditViewModel: ObservableObject {
    @Published var name = ""
    @Published var currency = Currency.yen
    @Published var selectedBank: Bank?
    @Published var selectedBankName = ""
    @Published var showingError = false
    @Published var showingDeleteAlert = false
    var originallySelectedBank: Bank?
    let realm = try! Realm()
    
    func saveChanges(_ editingCreditCard: CreditCard?, completion: ((Bool) -> ())) {
        // check for invalid input
        if name.isEmpty || (selectedBank != nil && currency != selectedBank!.currency) {
            showingError = true
            completion(false)
            return
        }
        
        // get the id and delete the card we're currently editing
        var id = ""
        if let card = editingCreditCard {
            id = card.id
            try! realm.write {
                realm.delete(realm.objects(CreditCardModel.self).filter("id=%@", card.id))
            }
        } else {
            id = UUID().uuidString
        }
        
        // save the changes as a new credit card model
        let newCard = CreditCard(id: id, name: name, currency: currency, linkedBankId: selectedBank?.id, recentTransactionIds: editingCreditCard?.recentTransactionIds ?? [])
        let newDBObj = CreditCardModel(creditCard: newCard)
        try! realm.write {
            realm.add(newDBObj)
        }
        
        // modify the linked or unlinked bank model
        if selectedBank?.id ?? "" != originallySelectedBank?.id ?? "" {
            if let selectedBank = selectedBank {
                modifyLinkedBank(bank: selectedBank, addingSelf: true, editingCardId: id)
            }
            if let originallySelectedBank = originallySelectedBank {
                modifyLinkedBank(bank: originallySelectedBank, addingSelf: false, editingCardId: id)
            }
        }
        
        // exit the view
        completion(true)
    }
    
    func deleteCreditCard(_ editingCreditCard: CreditCard?, completion: ((Bool) -> ())) {
        if let card = editingCreditCard {
            try! realm.write {
                realm.delete(realm.objects(CreditCardModel.self).filter("id=%@", card.id))
            }
        }
        
        // modify the linked bank model
        if let linkedBank = originallySelectedBank {
            modifyLinkedBank(bank: linkedBank, addingSelf: false, editingCardId: editingCreditCard!.id)
        }
        
        // exit the view
        completion(true)
    }
    
    func modifyLinkedBank(bank: Bank, addingSelf: Bool, editingCardId: String) {
        let bankObjs = realm.objects(BankModel.self)
        let filterRes = bankObjs.where {
            $0.id == bank.id
        }
        let bankToModify = filterRes[0]
        var tempBank = Bank(bankToModify)
        if addingSelf {
            tempBank.linkedCreditCardIds.append(editingCardId)
        } else {
            tempBank.linkedCreditCardIds.remove(at: tempBank.linkedCreditCardIds.firstIndex(of: editingCardId)!)
        }
        let resultingBankObj = BankModel(bank: tempBank)
        try! realm.write {
            realm.delete(realm.objects(BankModel.self).filter("id=%@", bankToModify.id))
            realm.add(resultingBankObj)
        }
    }
}
