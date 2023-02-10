struct Bank: Hashable, Equatable {
    var id: String
    var name: String
    var currency: Currency
    var availableBalance: Double
    var monthlyDeposit: Double
    var linkedCreditCardIds: [String]
    var recentTransactionIds: [String]
    
    static func == (lhs: Bank, rhs: Bank) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: String, name: String, currency: Currency, availableBalance: Double, monthlyDeposit: Double, linkedCreditCardIds: [String] = [], recentTransactionIds: [String] = []) {
        self.id = id
        self.name = name
        self.currency = currency
        self.availableBalance = availableBalance
        self.monthlyDeposit = monthlyDeposit
        self.linkedCreditCardIds = linkedCreditCardIds
        self.recentTransactionIds = recentTransactionIds
    }
    
    init(_ dbObj: BankModel) {
        self.id = dbObj.id
        self.name = dbObj.name
        self.currency = Currency(rawValue: dbObj.currency)!
        self.availableBalance = dbObj.availableBalance
        self.monthlyDeposit = dbObj.monthlyDeposit
        var ids = [String]()
        ids.append(contentsOf: dbObj.linkedCreditCardIds)
        self.linkedCreditCardIds = ids
        ids = [String]()
        ids.append(contentsOf: dbObj.recentTransactionIds)
        self.recentTransactionIds = ids
    }
}
