import SwiftUI

struct CalendarDayCellView: View {
    @ObservedObject var viewModel: CalendarDayCellViewModel
    
    init(calendarDay: CalendarDay, onSelectTransaction: @escaping ((Int) -> ())) {
        viewModel = CalendarDayCellViewModel(calendarDay: calendarDay, onSelectTransaction: onSelectTransaction)
    }
    
    func calculateTransactionTotal() {
        var sum = 0
        for transaction in viewModel.calendarDay.transactions {
            if transaction.isSpend {
                if transaction.currency == .yen {
                    sum += Int(transaction.amount)
                } else {
                    sum += Int(transaction.amount * 100)
                }
            }
        }
        viewModel.spendingTotal = sum
        
        sum = 0
        for transaction in viewModel.calendarDay.transactions {
            if !transaction.isSpend {
                if transaction.currency == .yen {
                    sum += Int(transaction.amount)
                } else {
                    sum += Int(transaction.amount * 100)
                }
            }
        }
        viewModel.earningsTotal = sum
    }
    
    var body: some View {
        Button {
            if viewModel.calendarDay.day > 0 {
                 if !viewModel.calendarDay.transactions.isEmpty {
                     viewModel.onSelectTransaction(viewModel.calendarDay.day)
                }
            }
        } label: {
            if viewModel.calendarDay.day > 0 {
                VStack {
                    HStack {
                        Text("\(viewModel.calendarDay.day)")
                            .padding(5)
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    
                    if viewModel.spendingTotal != 0 {
                        Text("-\(viewModel.spendingTotal)")
                            .font(.system(size: 10))
                            .foregroundColor(.red)
                    } else {
                        Spacer()
                    }
                    
                    if viewModel.earningsTotal != 0 {
                        Text("+\(viewModel.earningsTotal)")
                            .font(.system(size: 10))
                            .foregroundColor(.green)
                    } else {
                        Spacer()
                    }
                }
                .background(.gray)
                .frame(width: viewModel.size, height: viewModel.size)
            } else {
                Color.gray
            }
        }
        .frame(width: viewModel.size, height: viewModel.size)
        .onAppear {
            calculateTransactionTotal()
        }
    }
}
