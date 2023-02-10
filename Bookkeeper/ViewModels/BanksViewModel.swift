import Foundation
import SwiftUI
import RealmSwift

class BanksViewModel: ObservableObject {
    @Published var savedBanks: [Bank] = []
    @Published var savedCreditCards: [CreditCard] = []
    @Published var showingAddNewAlert = false
    @Published var showingBankDetailView = false
    @Published var showingCreditCardDetailView = false
    let realm = try! Realm()
    
    func resetList() {
        let bankObjects = realm.objects(BankModel.self)
        var banks = [Bank]()
        for obj in bankObjects {
            banks.append(Bank(obj))
        }
        savedBanks = banks
        
        let cardObjects = realm.objects(CreditCardModel.self)
        var creditCards = [CreditCard]()
        for obj in cardObjects {
            creditCards.append(CreditCard(obj))
        }
        savedCreditCards = creditCards
    }
}
