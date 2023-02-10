import SwiftUI
import RealmSwift

struct BankDetailEditView: View {
    @StateObject var viewModel = BankDetailEditViewModel()
    var editingBank: Bank?
    let availableCreditCards: [CreditCard]
    let editCompletion: (() -> ())?
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
                    if currency == .yen {
                        viewModel.availableBalance = "0"
                        viewModel.monthlyDeposit = "0"
                    } else {
                        viewModel.availableBalance = "0.00"
                        viewModel.monthlyDeposit = "0.00"
                    }
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
                        editCompletion?()
                        dismiss()
                    }
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK", role: .cancel) { }
        }
        .alert(isPresented: $viewModel.showingDeleteAlert) {
            Alert(
                title: Text("Are you sure you want to delete this bank?"),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteBank(editingBank) { successful in
                        if successful {
                            editCompletion?()
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
                viewModel.availableBalance = String(bank.availableBalance)
                viewModel.monthlyDeposit = String(bank.monthlyDeposit)
                
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
