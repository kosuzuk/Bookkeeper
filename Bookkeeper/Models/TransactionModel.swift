import Foundation
import RealmSwift

class TransactionModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var date = Date()
    @objc dynamic var amount = 0.0
    @objc dynamic var currency = ""
    @objc dynamic var spending = true
    @objc dynamic var bankId: String?
    @objc dynamic var creditCardId: String?
    @objc dynamic var title = ""
    @objc dynamic var details = ""
    @objc dynamic var expenseCategory: String?
    @objc dynamic var incomeCategory: String?
    
    convenience init(id: String, date: Date, amount: Double, currency: String, spending: Bool, bankId: String? = nil, creditCardId: String? = nil, title: String, details: String, expenseCategory: String? = nil, incomeCategory: String? = nil) {
        self.init()
        self.id = id
        self.date = date
        self.amount = amount
        self.currency = currency
        self.spending = spending
        self.bankId = bankId
        self.creditCardId = creditCardId
        self.title = title
        self.details = details
        self.expenseCategory = expenseCategory
        self.incomeCategory = incomeCategory
    }
    
    convenience init(transaction: Transaction) {
        self.init()
        self.id = transaction.id
        self.date = transaction.date
        self.amount = transaction.amount
        self.currency = transaction.currency
        self.spending = transaction.isSpend
        if let id = transaction.bankId {
            self.bankId = id
        }
        if let id = transaction.creditCardId {
            self.creditCardId = id
        }
        self.title = transaction.title
        self.details = transaction.details
        self.expenseCategory = transaction.expenseCategory?.rawValue
        self.incomeCategory = transaction.incomeCategory?.rawValue
    }
}
