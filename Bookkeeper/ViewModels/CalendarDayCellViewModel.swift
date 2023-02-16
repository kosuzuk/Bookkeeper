import Foundation
import SwiftUI

class CalendarDayCellViewModel: ObservableObject {
    @Published var spendingTotal = 0
    @Published var earningsTotal = 0
    @Published var calendarDay: CalendarDay
    let onSelectTransaction: ((Int) -> ())
    let size = (Device.width - 40) / 7
    
    init(calendarDay: CalendarDay, onSelectTransaction: @escaping ((Int) -> ())) {
        self.calendarDay = calendarDay
        self.onSelectTransaction = onSelectTransaction
    }
}
