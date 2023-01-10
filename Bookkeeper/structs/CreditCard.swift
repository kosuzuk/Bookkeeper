struct CreditCard {
    var id: String
    var name: String
    var linkedBankId: String?
    var recentTransactionIds: [String]
    
    init(id: String, name: String, linkedBankId: String? = nil, recentTransactionIds: [String] = []) {
        self.id = id
        self.name = name
        self.linkedBankId = linkedBankId
        self.recentTransactionIds = recentTransactionIds
    }
    
    init(_ dbObj: CreditCardModel) {
        self.id = dbObj.id
        self.name = dbObj.name
        if let id = dbObj.linkedBankId {
            self.linkedBankId = id
        }
        var ids = [String]()
        ids.append(contentsOf: dbObj.recentTransactionIds)
        self.recentTransactionIds = ids
    }
}
