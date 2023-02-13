import Foundation

struct CalendarDay {
    var day: Int
    var transactions: [Transaction]
    let id = UUID().uuidString
    
    init(day: Int, transactions: [Transaction]) {
        self.day = day
        self.transactions = transactions
    }
}
