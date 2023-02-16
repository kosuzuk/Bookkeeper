import Foundation
import SwiftUI

struct CalendarView: View {
    @StateObject var viewModel = CalendarViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button("<") {
                    viewModel.monthChangeButtonOnPress(goBack: true)
                }
                
                Text(viewModel.curMonthTitle)
                
                Button(">") {
                    viewModel.monthChangeButtonOnPress(goBack: false)
                }
            }
            
            Spacer()
                .frame(height: 60)
            
            LazyVGrid(columns: viewModel.columns, spacing: 10) {
                ForEach(viewModel.calendarDays, id: \.id) { calendarDay in
                    ZStack {
                        CalendarDayCellView(calendarDay: calendarDay, onSelectTransaction: { date in viewModel.selectedDate = date })
                        
                        if calendarDay.day + viewModel.firstWeekday < 9 {
                            Text(viewModel.weekdays[calendarDay.day + viewModel.firstWeekday - 2])
                                .foregroundColor(.gray)
                                .offset(y: -((Device.width - 40) / 7) / 2 - 10)
                        }
                    }
                }
            }
            
            Spacer()
            
            if let date = viewModel.selectedDate {
                TransactionsListView(transactions: viewModel.calendarDays[viewModel.firstWeekday + date - 2].transactions)
            }
        }
    }
}
