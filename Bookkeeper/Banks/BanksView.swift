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
                        NavigationLink(destination: BankDetailView(bank: bank, availableCreditCards: viewModel.savedCreditCards, editCompletion: viewModel.resetList)) {
                            Text(bank.name)
                        }
                    }
                    
                    Text("Total:")
                    
                    HStack(spacing: 20) {
                        ForEach(viewModel.getAvailableCurrencies(), id: \.self) { currency in
                            Text(currency.symbol)
                            
                            Text(String(viewModel.getTotalAmountForCurrency(currency: currency)))
                        }
                    }
                    
                    Text("Credit Cards:")
                    
                    ForEach(viewModel.savedCreditCards, id: \.id) { card in
                        NavigationLink(destination: CreditCardDetailView(creditCard: card, availableBanks: viewModel.savedBanks, editCompletion: viewModel.resetList)) {
                            Text(card.name)
                        }
                    }
                    
                    Spacer()
                    
                    Button("Add New") {
                        viewModel.showingAddNewAlert = true
                    }
                    .foregroundColor(.red)
                    
                    VStack {
                        NavigationLink(destination: BankDetailEditView(availableCreditCards: viewModel.savedCreditCards, editCompletion: viewModel.resetList), isActive: $viewModel.showingBankDetailView) { EmptyView() }
                        
                        NavigationLink(destination: CreditCardDetailEditView(availableBanks: viewModel.savedBanks, editCompletion: viewModel.resetList), isActive: $viewModel.showingCreditCardDetailView) { EmptyView() }
                    }
                }
            }
        }
        .onAppear {
//            let realm = try! Realm()
//            try! realm.write {
//                realm.deleteAll()
//            }

            viewModel.resetList()
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
