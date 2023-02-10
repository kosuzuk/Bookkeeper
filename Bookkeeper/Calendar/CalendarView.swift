import Foundation
import SwiftUI

struct CalendarView: View {
    @StateObject var viewModel = CalendarViewModel()
    
    var body: some View {
        LazyVGrid(columns: viewModel.columns, spacing: 10) {
            ForEach(viewModel.calendarDays, id: \.day) { day in
                CalendarDayButtonView(calendarDay: day)
            }
        }
        .padding(20)
        .onAppear {
            viewModel.fetchTransactions()
        }
    }
}
