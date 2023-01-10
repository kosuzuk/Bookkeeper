import SwiftUI

struct RootView: View {
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            CalendarView()
                .tabItem {
                    if selection == 0 {
                        Image("")
                    } else {
                        Image("")
                    }
                    Text("Calendar")
                }
                .tag(0)

            TransactionsView()
                .tabItem {
                    if selection == 1 {
                        Image("")
                    } else {
                        Image("")
                    }
                    Text("List")
                }
                .tag(1)
            
            GraphsView()
                .tabItem {
                    if selection == 2 {
                        Image("")
                    } else {
                        Image("")
                    }
                    Text("Overview")
                }
                .tag(2)
            
            BanksView()
                .tabItem {
                    if selection == 3 {
                        Image("")
                    } else {
                        Image("")
                    }
                    Text("My Banks")
                }
                .tag(3)
        }
    }
}
