import Foundation

extension Double {
    func toAmountString(currency: Currency) -> String {
        var res = ""
        
        if currency == .yen {
            res = String(Int(self))
        } else {
            let str = String(self)
            let dotPos = str.distance(from: str.startIndex, to: str.firstIndex(of: ".")!)
            if dotPos == str.count - 2 {
                res = str + "0"
            } else {
                res = String(str.prefix(dotPos + 3))
            }
        }
        
        return res
    }
}

extension Date {
    func toReadableFormat(using format: String) -> String {
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: Date())))!
    }
    
    static func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    static func getDateRangeForCurrentMonth() -> [Date] {
        [self.startOfMonth(), self.endOfMonth()]
    }
}
