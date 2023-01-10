import Foundation

struct Transaction {
    var id: String
    var date: Date
    var amount: Int
    var spending: Bool
    var bankId: String?
    var creditCardId: String?
    var title: String
    var details: String
    
    init(id: String, date: Date, amount: Int, spending: Bool, bankId: String? = nil, creditCardId: String? = nil, title: String = "", details: String = "") {
        self.id = id
        self.date = date
        self.amount = amount
        self.spending = spending
        self.bankId = bankId
        self.creditCardId = creditCardId
        self.title = title
        self.details = details
    }
    
    init(_ dbObj: TransactionModel) {
        self.id = dbObj.id
        self.date = dbObj.date
        self.amount = dbObj.amount
        self.spending = dbObj.spending
        if let id = dbObj.bankId {
            self.bankId = id
        }
        if let id = dbObj.creditCardId {
            self.creditCardId = id
        }
        self.title = dbObj.title
        self.details = dbObj.details
    }
}
