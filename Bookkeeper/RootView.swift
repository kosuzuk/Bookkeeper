import SwiftUI

struct RootView: View {
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            TransactionEntryView()
                .tabItem {
                    if selection == 0 {
                        Image("")
                    } else {
                        Image("")
                    }
                    Text("New Entry")
                }
                .tag(0)
            
            CalendarView()
                .tabItem {
                    if selection == 1 {
                        Image("")
                    } else {
                        Image("")
                    }
                    Text("Calendar")
                }
                .tag(1)

            TransactionsView()
                .tabItem {
                    if selection == 2 {
                        Image("")
                    } else {
                        Image("")
                    }
                    Text("List")
                }
                .tag(2)
            
            OverviewView()
                .tabItem {
                    if selection == 3 {
                        Image("")
                    } else {
                        Image("")
                    }
                    Text("Overview")
                }
                .tag(3)
            
            BanksView()
                .tabItem {
                    if selection == 4 {
                        Image("")
                    } else {
                        Image("")
                    }
                    Text("My Banks")
                }
                .tag(4)
        }
        .environment(\.colorScheme, .light)
        .onAppear {
//            let realm = try! Realm()
//            try! realm.write {
//                realm.deleteAll()
//            }
        }
    }
}

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
