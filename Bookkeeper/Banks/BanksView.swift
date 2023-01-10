import SwiftUI
import RealmSwift

struct BanksView: View {
    @State var savedBanks: [Bank] = []
    
    func resetBanks() {
        let realm = try! Realm()
        let objects = realm.objects(BankModel.self)
        var banks = [Bank]()
        for obj in objects {
            banks.append(Bank(obj))
        }
        savedBanks = banks
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 40) {
                    Spacer().frame(width: 40)
                    
                    ForEach(savedBanks, id: \.id) { bank in
                        NavigationLink(destination: BankDetailView(bank: bank, editCompletion: resetBanks)) {
                            Text(bank.name)
                        }
                    }
                    
                    NavigationLink(destination: BankDetailEditView(editCompletion: resetBanks)) {
                        Text("Add bank")
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            resetBanks()
        }
    }
}
