import SwiftUI
import RealmSwift

struct BanksView: View {
    @StateObject var viewModel = BanksViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 40) {
                    Spacer().frame(width: 40)
                    
                    Text("Banks:")
                    
                    ForEach(viewModel.savedBanks, id: \.id) { bank in
                        NavigationLink(destination: BankDetailView(bank: bank, availableCreditCards: viewModel.savedCreditCards)) {
                            Text(bank.name)
                        }
                    }
                    
                    Text("Total:")
                    
                    HStack(spacing: 30) {
                        ForEach(viewModel.getAvailableCurrencies(), id: \.self) { currency in
                            HStack(spacing: 3) {
                                Text(currency.symbol)
                                
                                Text(viewModel.getTotalAmountStrForCurrency(currency: currency))
                            }
                        }
                    }
                    
                    Text("Credit Cards:")
                    
                    ForEach(viewModel.savedCreditCards, id: \.id) { card in
                        NavigationLink(destination: CreditCardDetailView(creditCard: card, availableBanks: viewModel.savedBanks)) {
                            Text(card.name)
                        }
                    }
                    
                    Spacer()
                    
                    Button("Add New") {
                        viewModel.showingAddNewAlert = true
                    }
                    .foregroundColor(.red)
                    
                    VStack {
                        NavigationLink(destination: BankDetailEditView(editingBank: Binding.constant(nil), availableCreditCards: viewModel.savedCreditCards), isActive: $viewModel.showingBankDetailView) { EmptyView() }
                        
                        NavigationLink(destination: CreditCardDetailEditView(editingCreditCard: Binding.constant(nil), availableBanks: viewModel.savedBanks), isActive: $viewModel.showingCreditCardDetailView) { EmptyView() }
                    }
                }
            }
            .onAppear {
                viewModel.resetList()
            }
        }
        .alert(isPresented: $viewModel.showingAddNewAlert) {
            Alert(
                title: Text("What would you like to add?"),
                primaryButton: .default(Text("Bank")) {
                    viewModel.showingBankDetailView = true
                },
                secondaryButton: .default(Text("Credit Card")) {
                    viewModel.showingCreditCardDetailView = true
                }
            )
        }
    }
}
