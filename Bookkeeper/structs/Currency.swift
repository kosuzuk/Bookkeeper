enum Currency: String, CaseIterable {
    case yen
    case usd
    case aud
    case euro
    
    var symbol: String {
        switch self {
        case .yen:
            return "¥"
        case .usd:
            return "$"
        case .aud:
            return "AUD"
        case .euro:
            return "€"
        }
    }
}
