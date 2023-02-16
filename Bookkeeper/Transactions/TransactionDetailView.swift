import SwiftUI

struct TransactionDetailView: View {
    let entry: Transaction
    
    var body: some View {
        VStack {
            Text(entry.date.toReadableFormat(using: "MMMM d, yyyy"))
            
            Text("\(entry.currency.symbol)\(entry.isSpend ? "-" : "+")\(entry.amount.toAmountString(currency: entry.currency))")
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
    }
}
