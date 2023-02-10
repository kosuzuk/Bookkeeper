struct CalendarDay {
    var day: Int
    var transactions: [Transaction]
    
    init(day: Int, transactions: [Transaction]) {
        self.day = day
        self.transactions = transactions
    }
}
