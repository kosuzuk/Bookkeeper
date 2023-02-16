import SwiftUI

struct TransactionsListView: View {
    var transactions: [Transaction]? = nil
    var dateRange: [Date]? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(transactions ?? [], id: \.id) { transaction in
                    NavigationLink {
                        TransactionDetailView(entry: transaction)
                    } label: {
                        TransactionCellView(entry: transaction)
                    }
                }
            }
        }
        .onAppear {
            if transactions == nil {
                // fetch data using date range
            }
        }
    }
}
