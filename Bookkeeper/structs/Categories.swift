struct ExpenseCategory {
    let name: String
    let imageName: String
    
    init(type: ExpenseCategoryType) {
        name = type.rawValue
        
        switch type {
        case .food:
            imageName = ""
        default:
            imageName = ""
        }
    }
}

struct IncomeCategory {
    let name: String
    let imageName: String
    
    init(type: IncomeCategoryType) {
        name = type.rawValue
        
        switch type {
        case .salary:
            imageName = ""
        default:
            imageName = ""
        }
    }
}

enum ExpenseCategoryType: String, CaseIterable {
    case food
    case clothing
    case medical
    case utilities
    case transportation
    case phone
    case housing
    case recreation
}

enum IncomeCategoryType: String, CaseIterable {
    case salary
    case bonus
    case investment
}
