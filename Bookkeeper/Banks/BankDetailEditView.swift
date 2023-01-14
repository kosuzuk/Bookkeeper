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
                
                VStack {
                    Text("Available balance")
                    
                    TextField("", text: $viewModel.availableBalance)
                        .frame(width: 200, height: 40)
                        .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 1)
                        )
                }
                
                VStack {
                    Text("Monthly deposit")
                    
                    TextField("", text: $viewModel.monthlyDeposit)
                        .frame(width: 200, height: 40)
                        .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 1)
                        )
                }
                
                VStack {
                    HStack {
                        Text("Link to credit card(s):")
                        
                        Button {
                            viewModel.showingCreditCardList.toggle()
                        } label: {
                            if viewModel.showingCreditCardList {
                                Text("▼")
                            } else {
                                Text("▲")
                            }
                        }
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
        .overlay(
            VStack {
                if viewModel.showingCreditCardList {
                    ForEach(availableCreditCards, id: \.id) { card in
                        Button((viewModel.isCreditCardSelected(card.id) ? "✓" : "") + card.name) {
                            if viewModel.isCreditCardSelected(card.id) {
                                let ind = viewModel.selectedCreditCards.firstIndex(where: { $0.id == card.id })!
                                viewModel.selectedCreditCards.remove(at: ind)
                                viewModel.showingCreditCardList = false
                            } else {
                                if card.linkedBankId == nil {
                                    viewModel.selectedCreditCards.append(card)
                                    viewModel.showingCreditCardList = false
                                }
                            }
                        }
                        .foregroundColor(viewModel.creditCardTaken(card.linkedBankId ?? "", editingBank?.id ?? "") ? .gray : .black)
                    }
                }
            }
            .padding(EdgeInsets(top: 240, leading: 0, bottom: 0, trailing: 0))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray, lineWidth: 1)
            )
        )
        .gesture(
            TapGesture()
                .onEnded { _ in
                    viewModel.showingCreditCardList = false
                }
        )
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
                viewModel.availableBalance = String(bank.availableBalance)
                viewModel.monthlyDeposit = String(bank.monthlyDeposit)
                
                var cards: [CreditCard] = []
                for id in bank.linkedCreditCardIds {
                    if let ind = availableCreditCards.firstIndex(where: { $0.id == id }) {
                        cards.append(availableCreditCards[ind])
                    }
                }
                viewModel.originallySelectedCreditCards = cards
                viewModel.selectedCreditCards = cards
            }
        }
    }
}
