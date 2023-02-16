import SwiftUI
import RealmSwift

struct BankDetailEditView: View {
    @StateObject var viewModel = BankDetailEditViewModel()
    @Binding var editingBank: Bank?
    let availableCreditCards: [CreditCard]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                VStack {
                    Text("Name of bank:")
                    
                    TextField("", text: $viewModel.name)
                        .frame(width: 200, height: 40)
                        .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 1)
                        )
                }
                
                Text("Currency:")
                
                Picker("Currency", selection: $viewModel.currency) {
                    ForEach(Currency.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .onChange(of: viewModel.currency) { currency in
                    viewModel.availableBalance = ""
                    viewModel.monthlyDeposit = ""
                }
                
                VStack {
                    Text("Available balance")
                    
                    HStack {
                        Text("\(viewModel.currency.symbol)")
                        
                        TextField("", text: $viewModel.availableBalance)
                            .frame(width: 200, height: 40)
                            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.gray, lineWidth: 1)
                            )
                            .keyboardType(viewModel.currency == .yen ? .numberPad : .decimalPad)
                    }
                }
                
                VStack {
                    Text("Monthly deposit")
                    
                    HStack {
                        Text("\(viewModel.currency.symbol)")
                        
                        TextField("", text: $viewModel.monthlyDeposit)
                            .frame(width: 200, height: 40)
                            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.gray, lineWidth: 1)
                            )
                            .keyboardType(viewModel.currency == .yen ? .numberPad : .decimalPad)
                    }
                }
                
                Spacer()

                if editingBank != nil {
                    Button("Delete bank") {
                        viewModel.showingDeleteAlert = true
                    }
                    .foregroundColor(.red)
                    .padding(20)
                }
            }
        }
        .navigationTitle("Edit Bank Info")
        .toolbar {
            Button("Done") {
                viewModel.saveChanges(editingBank) { successful in
                    if successful {
                        editingBank?.name = viewModel.name
                        editingBank?.currency = viewModel.currency
                        editingBank?.availableBalance = Double(viewModel.availableBalance)!
                        editingBank?.monthlyDeposit = Double(viewModel.monthlyDeposit)!
                        editingBank?.linkedCreditCardIds = viewModel.linkedCreditCards.map { $0.id }
                        
                        dismiss()
                    }
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK", role: .cancel) {}
        }
        .alert(isPresented: $viewModel.showingDeleteAlert) {
            Alert(
                title: Text("Are you sure you want to delete this bank?"),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteBank(editingBank) { successful in
                        if successful {
                            dismiss()
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            if let bank = editingBank {
                viewModel.name = bank.name
                viewModel.currency = bank.currency
                viewModel.availableBalance = bank.availableBalance.toAmountString(currency: bank.currency)
                viewModel.monthlyDeposit = bank.monthlyDeposit.toAmountString(currency: bank.currency)
                
                var cards: [CreditCard] = []
                for id in bank.linkedCreditCardIds {
                    if let ind = availableCreditCards.firstIndex(where: { $0.id == id }) {
                        cards.append(availableCreditCards[ind])
                    }
                }
                viewModel.linkedCreditCards = cards
            }
        }
    }
}
