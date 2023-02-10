import SwiftUI

struct BankDetailView: View {
    let bank: Bank?
    let availableCreditCards: [CreditCard]
    let editCompletion: (() -> ())?
    
    func cardIdToName(_ id: String) -> String {
        let ind = availableCreditCards.firstIndex(where: { $0.id == id })!
        return availableCreditCards[ind].name
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Spacer().frame(width: 40)

                NavigationLink(destination: BankDetailEditView(editingBank: bank, availableCreditCards: availableCreditCards, editCompletion: editCompletion)) {
                    Text("Edit")
                }
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.blue, lineWidth: 1)
                )
                
                VStack {
                    Text("Available Balance:")

                    Text("\(Currency(rawValue: bank?.currency.rawValue ?? "")?.symbol ?? "")\(bank?.availableBalance ?? 0)")
                }

                VStack {
                    Text("Monthly deposit:")

                    Text("\(Currency(rawValue: bank?.currency.rawValue ?? "")?.symbol ?? "")\(bank?.monthlyDeposit ?? 0)")
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
