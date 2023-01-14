import SwiftUI
import RealmSwift

struct BanksView: View {
    @State var savedBanks: [Bank] = []
    @State var savedCreditCards: [CreditCard] = []
    @State var showingAddNewAlert = false
    @State var showingBankDetailView = false
    @State var showingCreditCardDetailView = false
    
    func resetList() {
        let realm = try! Realm()
        
        let bankObjects = realm.objects(BankModel.self)
        var banks = [Bank]()
        for obj in bankObjects {
            banks.append(Bank(obj))
        }
        savedBanks = banks
        
        let cardObjects = realm.objects(CreditCardModel.self)
        var creditCards = [CreditCard]()
        for obj in cardObjects {
            creditCards.append(CreditCard(obj))
        }
        savedCreditCards = creditCards
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 40) {
                    Spacer().frame(width: 40)
                    
                    Text("Banks:")
                    
                    ForEach(savedBanks, id: \.id) { bank in
                        NavigationLink(destination: BankDetailView(bank: bank, availableCreditCards: savedCreditCards, editCompletion: resetList)) {
                            Text(bank.name)
                        }
                    }
                    
                    Text("Credit Cards:")
                    
                    ForEach(savedCreditCards, id: \.id) { card in
                        NavigationLink(destination: CreditCardDetailView(creditCard: card, availableBanks: savedBanks, editCompletion: resetList)) {
                            Text(card.name)
                        }
                    }
                    
                    Spacer()

                    Button("Add New") {
                        showingAddNewAlert = true
                    }
                    .foregroundColor(.red)
                    
                    NavigationLink(destination: BankDetailEditView(availableCreditCards: savedCreditCards, editCompletion: resetList), isActive: $showingBankDetailView) { EmptyView() }
                    
                    NavigationLink(destination: CreditCardDetailEditView(availableBanks: savedBanks, editCompletion: resetList), isActive: $showingCreditCardDetailView) { EmptyView() }
                }
            }
        }
        .onAppear {
//            let realm = try! Realm()
//            try! realm.write {
//                realm.deleteAll()
//            }

            resetList()
        }
        .alert(isPresented: $showingAddNewAlert) {
            Alert(
                title: Text("What would you like to add?"),
                primaryButton: .default(Text("Bank")) {
                    showingBankDetailView = true
                },
                secondaryButton: .default(Text("Credit Card")) {
                    showingCreditCardDetailView = true
                }
            )
        }
    }
}
