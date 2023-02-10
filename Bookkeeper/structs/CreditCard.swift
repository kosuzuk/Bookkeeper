struct CreditCard: Hashable, Equatable {
    var id: String
    var name: String
    var currency: Currency
    var linkedBankId: String?
    var recentTransactionIds: [String]
    
    static func == (lhs: CreditCard, rhs: CreditCard) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: String, name: String, currency: Currency, linkedBankId: String? = nil, recentTransactionIds: [String] = []) {
        self.id = id
        self.name = name
        self.currency = currency
        self.linkedBankId = linkedBankId
        self.recentTransactionIds = recentTransactionIds
    }
    
    init(_ dbObj: CreditCardModel) {
        self.id = dbObj.id
        self.name = dbObj.name
        self.currency = Currency(rawValue: dbObj.currency)!
        if let id = dbObj.linkedBankId {
            self.linkedBankId = id
        }
        var ids = [String]()
        ids.append(contentsOf: dbObj.recentTransactionIds)
        self.recentTransactionIds = ids
    }
}
