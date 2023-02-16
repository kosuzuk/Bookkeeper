import SwiftUI

struct TransactionCellView: View {
    let entry: Transaction
    
    var body: some View {
        HStack {
            Text(entry.date.toReadableFormat(using: "MM/dd/yyyy"))
            
            Text("\(entry.currency.symbol)\(entry.isSpend ? "-" : "+")\(entry.amount.toAmountString(currency: entry.currency))")
                .foregroundColor(entry.isSpend ? .red : .green)
        }
        .border(.gray, width: 1)
    }
}
