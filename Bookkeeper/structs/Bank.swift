struct Bank {
    var name: String
    var availableBalance: Int
    var monthlyDeposit: Int
    var linkedTo: CreditCard?
    var recentTransactions: [Transaction]
    
    init(name: String, availableBalance: Int, monthlyDeposit: Int, linkedTo: CreditCard? = nil, recentTransactions: [Transaction] = []) {
        self.name = name
        self.availableBalance = availableBalance
        self.monthlyDeposit = monthlyDeposit
        self.linkedTo = linkedTo
        self.recentTransactions = recentTransactions
    }
}
