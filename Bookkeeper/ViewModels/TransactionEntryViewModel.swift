import Foundation
import SwiftUI
import RealmSwift
class TransactionEntryViewModel: ObservableObject {
    @Published var isSpend = true
    @Published var date = Date()
    @Published var notes = ""
    @Published var amount = ""
    @Published var payWithBank = true
    @Published var bank = Bank(id: "", name: "None available", currency: .yen, availableBalance: 0, monthlyDeposit: 0)
    @Published var creditCard = CreditCard(id: "", name: "None available", currency: .yen)
    @Published var currency = Currency.yen
    @Published var expenseCategory: ExpenseCategoryType?
    @Published var incomeCategory: IncomeCategoryType?
    @Published var showingAlert = false
    @Published var showingError = false
    let realm = try! Realm()
    var availableBanks: [Bank] = []
    var availableCreditCards: [CreditCard] = []
    let categoryColumns = (0..<3).map({ _ in GridItem(.fixed((Device.width - 20) / 3)) })
    let availableExpenseCategories: [ExpenseCategory] = ExpenseCategoryType.allCases.map({ ExpenseCategory(type: $0) })
    let availableIncomeCategories: [IncomeCategory] = IncomeCategoryType.allCases.map({ IncomeCategory(type: $0) })
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(resetBanksAndCardsData), name: Notification.Name("bankInfoChanged"), object: nil)
    }
    
    @objc func resetBanksAndCardsData() {
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
                amount = ""
            } else {
                amount = ""
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
        let amountVal = Double(amount)!
        if amountVal == 0.0 || (bank.id.isEmpty && creditCard.id.isEmpty) {
            showingError = true
            return
        }
        
        // save the transaction
        let transaction = Transaction(id: UUID().uuidString, date: date, amount: amountVal, currency: currency, isSpend: isSpend)
        let transactionDBObj = TransactionModel(transaction: transaction)
        try! realm.write {
            realm.add(transactionDBObj)
        }
        
        // edit the bank or card data in db
        if payWithBank {
            let bankObj = realm.objects(BankModel.self).filter("id == %@", bank.id).first!
            try! realm.write {
                bankObj.recentTransactionIds.append(transactionDBObj.id)
                var val = isSpend ? -amountVal : amountVal
                bankObj.availableBalance += val
            }
        } else {
            let cardObj = realm.objects(CreditCardModel.self).filter("id == %@", creditCard.id).first!
            try! realm.write {
                cardObj.recentTransactionIds.append(transactionDBObj.id)
            }
        }
        
        resetFields()
        
        NotificationCenter.default.post(name: Notification.Name("newTransactionEntryAdded"), object: nil)
    }
    
    func resetFields() {
        notes = ""
        amount = ""
        payWithBank = true
        bank = Bank(id: "", name: "None available", currency: .yen, availableBalance: 0, monthlyDeposit: 0)
        creditCard = CreditCard(id: "", name: "None available", currency: .yen)
        currency = .yen
        expenseCategory = nil
        incomeCategory = nil
    }
}
