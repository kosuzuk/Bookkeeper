import Foundation
import SwiftUI
import RealmSwift

class CalendarViewModel: ObservableObject {
    @Published var calendarDays: [CalendarDay] = []
    let columns = (0..<7).map({ _ in GridItem(.fixed((Device.width - 40) / 7)) })
    
    init() {
        let calendar = Calendar.current
        let today = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: today)))!
        let weekday = calendar.component(.weekday, from: startOfMonth)
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let numDays = range.count
        
        for i in (2 - weekday)...numDays {
            calendarDays.append(CalendarDay(day: i, transactions: []))
        }
    }
    
    func fetchTransactions() {
        // TEMP
        calendarDays[15].transactions = [Transaction(id: "0", date: Date(), amount: 1500, currency: "yen", isSpend: true), Transaction(id: "1", date: Date(), amount: 3000, currency: "yen", isSpend: false)]
        calendarDays[20].transactions = [Transaction(id: "2", date: Date(), amount: 20000, currency: "yen", isSpend: false)]
    }
}
