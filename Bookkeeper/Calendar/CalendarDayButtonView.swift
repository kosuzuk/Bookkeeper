import SwiftUI

struct CalendarDayButtonView: View {
    @State var spendingTotal = 0.0
    @State var earningsTotal = 0.0
    let calendarDay: CalendarDay
    let size = (Device.width - 40) / 7
    
    var body: some View {
        Button {
            if calendarDay.day > 0 {
                print("calendar day tapped", calendarDay.transactions)
            }
        } label: {
            if calendarDay.day > 0 {
                VStack {
                    HStack {
                        Text("\(calendarDay.day)")
                            .padding(5)
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    if spendingTotal != 0 {
                        Text("-\(spendingTotal)")
                            .font(.system(size: 10))
                            .foregroundColor(.red)
                    }
                    
                    if earningsTotal != 0 {
                        Text("+\(earningsTotal)")
                            .font(.system(size: 10))
                            .foregroundColor(.green)
                    }
                }
                .background(.gray)
                .frame(width: size, height: size)
            } else {
                Color.gray
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            spendingTotal = calendarDay.transactions.reduce(0.0, { $0 + ($1.isSpend ? $1.amount : 0.0)})
            earningsTotal = calendarDay.transactions.reduce(0.0, { $0 + (!$1.isSpend ? $1.amount : 0.0)})
        }
    }
}
