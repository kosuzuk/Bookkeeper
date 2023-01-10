import Foundation
import RealmSwift

class CreditCardModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var linkedBankId: String? = nil
    var recentTransactionIds = List<String>()
    
    convenience init(id: String, name: String, linkedBankId: String? = nil, recentTransactionIds: List<String> = List<String>()) {
        self.init()
        self.id = id
        self.name = name
        self.linkedBankId = linkedBankId
        self.recentTransactionIds = recentTransactionIds
    }
    
    convenience init(creditCard: CreditCard) {
        self.init()
        self.id = creditCard.id
        self.name = creditCard.name
        if let id = creditCard.linkedBankId {
            self.linkedBankId = id
        }
        self.recentTransactionIds.append(objectsIn: creditCard.recentTransactionIds)
    }
}
