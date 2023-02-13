import Foundation
import SwiftUI
import RealmSwift

class CalendarViewModel: ObservableObject {
    @Published var calendarDays: [CalendarDay] = []
    @Published var monthDisplayed = 0
    @Published var yearDisplayed = 0
    @Published var selectedEntry: Transaction?
    var transactionsData: [TransactionModel] = []
    var firstWeekday = 0
    let columns = (0..<7).map({ _ in GridItem(.fixed((Device.width - 40) / 7)) })
    let realm = try! Realm()
    var curMonthTitle: String {
        let monthNames = ["January", "Feburuary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        return "\(monthNames[monthDisplayed - 1]) \(yearDisplayed)"
    }
    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    init() {
        let comps = Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: Date()))
        monthDisplayed = comps.month!
        yearDisplayed = comps.year!
        
        transactionsData = Array(realm.objects(TransactionModel.self))
        
        resetCalendarDays()
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetCalendarDays), name: Notification.Name("newTransactionEntryAdded"), object: nil)
    }
    
    @objc func resetCalendarDays() {
        calendarDays = []
        
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.month = monthDisplayed
        comps.year = yearDisplayed
        let startOfMonth = calendar.date(from: comps)!
        firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let numDays = range.count
        for i in (2 - firstWeekday)...numDays {
            calendarDays.append(CalendarDay(day: i, transactions: []))
        }
        
        resetTransactions()
    }
    
    func resetTransactions() {
        // Reset the data
        for i in 0..<calendarDays.count {
            calendarDays[i].transactions = []
        }
        
        // Add transaction data to calendar day objects
        for obj in transactionsData {
            let comps = Calendar.current.dateComponents([.year, .month, .day], from: obj.date)
            if comps.year == yearDisplayed, comps.month == monthDisplayed {
                calendarDays[(firstWeekday - 2) + comps.day!].transactions.append(Transaction(obj))
            }
        }
    }
    
    func monthChangeButtonOnPress(goBack: Bool) {
        if goBack {
            if monthDisplayed == 1 {
                monthDisplayed = 12
                yearDisplayed -= 1
            } else {
                monthDisplayed -= 1
            }
        } else {
            if monthDisplayed == 12 {
                monthDisplayed = 1
                yearDisplayed += 1
            } else {
                monthDisplayed += 1
            }
        }
        
        resetCalendarDays()
    }
}
