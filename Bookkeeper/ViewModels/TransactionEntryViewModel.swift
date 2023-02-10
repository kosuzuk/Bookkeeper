import Foundation
import SwiftUI
import RealmSwift
class TransactionEntryViewModel: ObservableObject {
    @Published var isSpend = true
    @Published var selectedDate = Date()
    @Published var notes = ""
    @Published var amount = "0"
    @Published var payWithBank = true
    @Published var bank = Bank(id: "", name: "None available", currency: .yen, availableBalance: 0, monthlyDeposit: 0)
    @Published var creditCard = CreditCard(id: "", name: "None available", currency: .yen)
    @Published var currency = Currency.yen
    @Published var expenseCategory: ExpenseCategoryType?
    @Published var incomeCategory: IncomeCategoryType?
    @Published var showingAlert = false
    let realm = try! Realm()
    var availableBanks: [Bank] = []
    var availableCreditCards: [CreditCard] = []
    let categoryColumns = (0..<3).map({ _ in GridItem(.fixed((Device.width - 20) / 3)) })
    let availableExpenseCategories: [ExpenseCategory] = ExpenseCategoryType.allCases.map({ ExpenseCategory(type: $0) })
    let availableIncomeCategories: [IncomeCategory] = IncomeCategoryType.allCases.map({ IncomeCategory(type: $0) })
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchBanksAndCards), name: Notification.Name("bankInfoChanged"), object: nil)
    }
    
    @objc func fetchBanksAndCards() {
        resetFields()
        
        let bankObjects = realm.objects(BankModel.self)
        var banks = [Bank]()
        for obj in bankObjects {
            banks.append(Bank(obj))
        }
        availableBanks = banks
        if let firstBank = availableBanks.first {
            bank = firstBank
            checkCurrencyChanged(newCurrency: bank.currency)
        }
        
        let cardObjects = realm.objects(CreditCardModel.self)
        var creditCards = [CreditCard]()
        for obj in cardObjects {
            creditCards.append(CreditCard(obj))
        }
        availableCreditCards = creditCards
        if let firstCard = availableCreditCards.first {
            creditCard = firstCard
            checkCurrencyChanged(newCurrency: creditCard.currency)
        }
    }
    
    func checkCurrencyChanged(newCurrency: Currency) {
        if currency != newCurrency {
            if newCurrency == .yen {
                amount = "0"
            } else {
                amount = "0.00"
            }
            currency = newCurrency
        }
    }
    
    func submit() {
        saveEntry()
        resetFields()
    }
    
    func saveEntry() {
        // check for invalid input
        let amountInt = Int(amount)
        if amountInt == nil || amountInt! < 0 {
//            showingError = true
//            completion(false)
            return
        }
    }
    
    func resetFields() {
        notes = ""
        amount = "0"
        payWithBank = true
        bank = Bank(id: "", name: "None available", currency: .yen, availableBalance: 0, monthlyDeposit: 0)
        creditCard = CreditCard(id: "", name: "None available", currency: .yen)
        currency = .yen
        expenseCategory = nil
        incomeCategory = nil
    }
}
