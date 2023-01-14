import SwiftUI
import RealmSwift

struct CreditCardDetailEditView: View {
    @StateObject var viewModel = CreditCardDetailEditViewModel()
    var editingCreditCard: CreditCard?
    let availableBanks: [Bank]
    let editCompletion: (() -> ())?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                VStack {
                    Text("Name of credit card:")
                    
                    TextField("", text: $viewModel.name)
                        .frame(width: 200, height: 40)
                        .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 1)
                        )
                }
                
                VStack {
                    HStack {
                        Text("Link to bank:")
                        
                        Button {
                            viewModel.showingBankList.toggle()
                        } label: {
                            if viewModel.showingBankList {
                                Text("▼")
                            } else {
                                Text("▲")
                            }
                        }
                    }
                }
                
                Spacer()
                
                if editingCreditCard != nil {
                    Button("Delete credit card") {
                        viewModel.showingDeleteAlert = true
                    }
                    .foregroundColor(.red)
                    .padding(20)
                }
            }
        }
        .navigationTitle("Edit Credit Card Info")
        .toolbar {
            Button("Done") {
                viewModel.saveChanges(editingCreditCard) { successful in
                    if successful {
                        editCompletion?()
                        dismiss()
                    }
                }
            }
        }
        .overlay(
            VStack {
                if viewModel.showingBankList {
                    ForEach(availableBanks, id: \.id) { bank in
                        Button((viewModel.isBankSelected(bank.id) ? "✓" : "") + bank.name) {
                            if viewModel.isBankSelected(bank.id) {
                                viewModel.selectedBank = nil
                                viewModel.showingBankList = false
                            } else {
                                viewModel.selectedBank = bank
                                viewModel.showingBankList = false
                            }
                        }
                        .foregroundColor(.black)
                    }
                }
            }
            .padding(EdgeInsets(top: 120, leading: 0, bottom: 0, trailing: 0))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray, lineWidth: 1)
            )
        )
        .gesture(
            TapGesture()
                .onEnded { _ in
                    viewModel.showingBankList = false
                }
        )
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK", role: .cancel) { }
        }
        .alert(isPresented: $viewModel.showingDeleteAlert) {
            Alert(
                title: Text("Are you sure you want to delete this card?"),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteCreditCard(editingCreditCard) { successful in
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
            if let card = editingCreditCard {
                viewModel.name = card.name
                
                if let id = card.linkedBankId, let ind = availableBanks.firstIndex(where: { $0.id == id }) {
                    viewModel.selectedBank = availableBanks[ind]
                    viewModel.originallySelectedBank = availableBanks[ind]
                }
            }
        }
    }
}
