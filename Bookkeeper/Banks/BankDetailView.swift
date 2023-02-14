import SwiftUI

struct BankDetailView: View {
    @State var bank: Bank?
    let availableCreditCards: [CreditCard]
    
    func cardIdToName(_ id: String) -> String {
        let ind = availableCreditCards.firstIndex(where: { $0.id == id })!
        return availableCreditCards[ind].name
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Spacer().frame(width: 40)

                NavigationLink(destination: BankDetailEditView(editingBank: $bank, availableCreditCards: availableCreditCards)) {
                    Text("Edit")
                }
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.blue, lineWidth: 1)
                )
                
                VStack {
                    Text("Available Balance:")

                    if let bank = bank {
                        Text(bank.currency.symbol + bank.availableBalance.toAmountString(currency: bank.currency))
                    }
                }

                VStack {
                    Text("Monthly deposit:")

                    if let bank = bank {
                        Text(bank.currency.symbol + bank.monthlyDeposit.toAmountString(currency: bank.currency))
                    }
                }

                VStack {
                    Text("Linked credit cards:")

                    if bank!.linkedCreditCardIds.isEmpty {
                        Text("None")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(bank!.linkedCreditCardIds, id: \.self) { id in
                            Text(cardIdToName(id))
                        }
                    }
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
