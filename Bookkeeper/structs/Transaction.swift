import Foundation

struct Transaction {
    var date = Date()
    var amount: Int
    var spending: Bool
    var bank: Bank?
    var creditCard: CreditCard?
    var title: String
    var details: String
    
    init(date: Date, amount: Int, spending: Bool, bank: Bank? = nil, creditCard: CreditCard? = nil, title: String = "", details: String = "") {
        self.date = date
        self.amount = amount
        self.spending = spending
        self.bank = bank
        self.creditCard = creditCard
        self.title = title
        self.details = details
    }
}
