struct Bank {
    var id: String
    var name: String
    var availableBalance: Int
    var monthlyDeposit: Int
    var linkedCreditCardIds: [String]
    var recentTransactionIds: [String]
    
    init(id: String, name: String, availableBalance: Int, monthlyDeposit: Int, linkedCreditCardIds: [String] = [], recentTransactionIds: [String] = []) {
        self.id = id
        self.name = name
        self.availableBalance = availableBalance
        self.monthlyDeposit = monthlyDeposit
        self.linkedCreditCardIds = linkedCreditCardIds
        self.recentTransactionIds = recentTransactionIds
    }
    
    init(_ dbObj: BankModel) {
        self.id = dbObj.id
        self.name = dbObj.name
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
