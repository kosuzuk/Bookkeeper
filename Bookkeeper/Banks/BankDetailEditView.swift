import SwiftUI

struct BankDetailEditView: View {
    @StateObject var viewModel = BankDetailEditViewModel()
    var editingBank: Bank?
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
                        Text("Link to credit card:")
                        
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
                
                if editingBank != nil {
                    Button("Delete bank") {
                        viewModel.showingDeleteAlert = true
                    }
                    .foregroundColor(.red)
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
                ForEach(viewModel.availableCreditCards, id: \.id) { card in
                    Button(card.name) {
                        viewModel.selectedCreditCards = [card]
                        viewModel.showingCreditCardList = false
                    }
                }
            }
            .padding(EdgeInsets(top: 200, leading: 20, bottom: 0, trailing: 0))
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
//                viewModel.selectedCreditCards = bank.linkedCreditCardIds
            }
        }
    }
}
