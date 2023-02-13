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
                        CalendarDayCellView(calendarDay: calendarDay)
                        
                        if calendarDay.day + viewModel.firstWeekday < 9 {
                            Text(viewModel.weekdays[calendarDay.day + viewModel.firstWeekday - 2])
                                .foregroundColor(.gray)
                                .offset(y: -((Device.width - 40) / 7) / 2 - 10)
                        }
                    }
                }
            }
            
            Spacer()
            
            if let entry = viewModel.selectedEntry {
                VStack {
                    Text("\(entry.currency.symbol)\(entry.isSpend ? "-" : "+")\(entry.amount)")
                        .foregroundColor(entry.isSpend ? .red : .green)
                    
                    //bank/card info
                    
                    Text("\(entry.title)")
                    
                    Text("\(entry.details)")
                    
                    if let category = entry.expenseCategory {
                        Text("\(category.rawValue)")
                    }
                    
                    if let category = entry.incomeCategory {
                        Text("\(category.rawValue)")
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray, lineWidth: 1)
                )
            }
        }
    }
}
