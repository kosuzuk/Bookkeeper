import Foundation

struct Transaction {
    var id: String
    var date: Date
    var amount: Double
    var currency: Currency
    var isSpend: Bool
    var bankId: String?
    var creditCardId: String?
    var title: String
    var details: String
    var expenseCategory: ExpenseCategoryType?
    var incomeCategory: IncomeCategoryType?
    
    init(id: String, date: Date, amount: Double, currency: Currency, isSpend: Bool, bankId: String? = nil, creditCardId: String? = nil, title: String = "", details: String = "", expenseCategory: ExpenseCategoryType? = nil, incomeCategory: IncomeCategoryType? = nil) {
        self.id = id
        self.date = date
        self.amount = amount
        self.currency = currency
        self.isSpend = isSpend
        self.bankId = bankId
        self.creditCardId = creditCardId
        self.title = title
        self.details = details
        self.expenseCategory = expenseCategory
        self.incomeCategory = incomeCategory
    }
    
    init(_ dbObj: TransactionModel) {
        self.id = dbObj.id
        self.date = dbObj.date
        self.amount = dbObj.amount
        self.currency = Currency(rawValue: dbObj.currency)!
        self.isSpend = dbObj.spending
        if let id = dbObj.bankId {
            self.bankId = id
        }
        if let id = dbObj.creditCardId {
            self.creditCardId = id
        }
        self.title = dbObj.title
        self.details = dbObj.details
        if let category = dbObj.expenseCategory {
            self.expenseCategory = ExpenseCategoryType(rawValue: category)
        }
        if let category = dbObj.incomeCategory {
            self.incomeCategory = IncomeCategoryType(rawValue: category)
        }
    }
}
