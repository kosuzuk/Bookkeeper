import SwiftUI

struct CreditCardDetailView: View {
    let creditCard: CreditCard?
    let availableBanks: [Bank]
    let editCompletion: (() -> ())?
    
    func bankIdToName(_ id: String) -> String {
        let ind = availableBanks.firstIndex(where: { $0.id == id })!
        return availableBanks[ind].name
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Spacer().frame(width: 40)

                NavigationLink(destination: CreditCardDetailEditView(editingCreditCard: creditCard, availableBanks: availableBanks, editCompletion: editCompletion)) {
                    Text("Edit")
                }
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.blue, lineWidth: 1)
                )
                
                HStack {
                    Text("Currency:")
                    
                    Text(creditCard!.currency.rawValue)
                }

                VStack {
                    Text("Linked bank:")

                    if creditCard!.linkedBankId == nil {
                        Text("None")
                            .foregroundColor(.gray)
                    } else {
                        Text(bankIdToName(creditCard!.linkedBankId!))
                    }
                }

                VStack {
                    Text("Recent transactions:")

                    Text(" ")
                }
            }
        }
        .navigationTitle(creditCard?.name ?? "")
    }
}
