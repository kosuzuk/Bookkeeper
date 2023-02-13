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
    
    func getTotalAmountForCurrency(currency: Currency) -> Double {
        return savedBanks.reduce(0) { $0 + (currency == $1.currency ? $1.availableBalance : 0) }
    }
    
    func getAvailableCurrencies() -> [Currency] {
        var res: [Currency] = []
        for bank in savedBanks {
            if !res.contains(bank.currency) {
                res.append(bank.currency)
            }
        }
        
        return res
    }
    
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
