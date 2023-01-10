import SwiftUI

struct BankDetailView: View {
    var bank: Bank?
    let editCompletion: (() -> ())?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Spacer().frame(width: 40)

                NavigationLink(destination: BankDetailEditView(editingBank: bank, editCompletion: editCompletion)) {
                    Text("Edit")
                }
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.blue, lineWidth: 1)
                )
                
                VStack {
                    Text("Available Balance:")

                    Text("\(bank?.availableBalance ?? 0)")
                }

                VStack {
                    Text("Monthly deposit:")

                    Text("\(bank?.monthlyDeposit ?? 0)")
                }

                VStack {
                    Text("Linked credit cards:")

                    Text(" ")
                }

                VStack {
                    Text("Recent transactions:")

                    Text(" ")
                }
            }
        }
        .navigationTitle(bank?.name ?? "")
    }
}
