import Foundation
import SwiftUI

class CalendarDayCellViewModel: ObservableObject {
    @Published var spendingTotal = 0
    @Published var earningsTotal = 0
    @Published var calendarDay: CalendarDay
    let size = (Device.width - 40) / 7
    
    init(calendarDay: CalendarDay) {
        self.calendarDay = calendarDay
    }
}
