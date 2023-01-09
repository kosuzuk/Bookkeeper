struct CreditCard {
    var name: String
    var recentTransactions: [Transaction]
    
    init(name: String, recentTransactions: [Transaction] = []) {
        self.name = name
        self.recentTransactions = recentTransactions
    }
}
