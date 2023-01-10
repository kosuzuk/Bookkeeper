import Foundation
import RealmSwift

class BankModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var availableBalance = 0
    @objc dynamic var monthlyDeposit = 0
    var linkedCreditCardIds = List<String>()
    var recentTransactionIds = List<String>()
    
    convenience init(id: String, name: String, availableBalance: Int, monthlyDeposit: Int, linkedCreditCardIds: List<String> = List<String>(), recentTransactionIds: List<String> = List<String>()) {
        self.init()
        self.id = id
        self.name = name
        self.availableBalance = availableBalance
        self.monthlyDeposit = monthlyDeposit
        self.linkedCreditCardIds = linkedCreditCardIds
        self.recentTransactionIds = recentTransactionIds
    }
    
    convenience init(bank: Bank) {
        self.init()
        self.id = bank.id
        self.name = bank.name
        self.availableBalance = bank.availableBalance
        self.monthlyDeposit = bank.monthlyDeposit
        self.linkedCreditCardIds.append(objectsIn: bank.linkedCreditCardIds)
        self.recentTransactionIds.append(objectsIn: bank.recentTransactionIds)
    }
}
