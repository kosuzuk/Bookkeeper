import Foundation
import RealmSwift

class TransactionModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var date = Date()
    @objc dynamic var amount = 0
    @objc dynamic var spending = true
    @objc dynamic var bankId: String?
    @objc dynamic var creditCardId: String?
    @objc dynamic var title = ""
    @objc dynamic var details = ""
    
    convenience init(id: String, date: Date, amount: Int, spending: Bool, bankId: String? = nil, creditCardId: String? = nil, title: String, details: String) {
        self.init()
        self.id = id
        self.date = date
        self.amount = amount
        self.spending = spending
        self.bankId = bankId
        self.creditCardId = creditCardId
        self.title = title
        self.details = details
    }
    
    convenience init(transaction: Transaction) {
        self.init()
        self.id = transaction.id
        self.date = transaction.date
        self.amount = transaction.amount
        self.spending = transaction.spending
        if let id = transaction.bankId {
            self.bankId = id
        }
        if let id = transaction.creditCardId {
            self.creditCardId = id
        }
        self.title = transaction.title
        self.details = transaction.details
    }
}
