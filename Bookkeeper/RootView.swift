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

            TransactionsListView(dateRange: Date.getDateRangeForCurrentMonth())
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
