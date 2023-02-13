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
                
                Text("Currency:")
                
                Picker("Currency", selection: $viewModel.currency) {
                    ForEach(Currency.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                
                HStack {
                    Text("Linked to :")
                    
                    Picker("No saved banks", selection: $viewModel.selectedBank) {
                        ForEach(availableBanks.map({ $0.name }), id: \.self) {
                            Text($0)
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
                viewModel.currency = card.currency
                
                if let id = card.linkedBankId, let ind = availableBanks.firstIndex(where: { $0.id == id }) {
                    viewModel.originallySelectedBank = availableBanks[ind]
                }
            }
            
            viewModel.selectedBank = availableBanks.first
        }
    }
}
