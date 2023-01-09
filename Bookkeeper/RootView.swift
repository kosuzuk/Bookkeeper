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
                    if selection == 0 {
                        Image("")
                    } else {
                        Image("")
                    }
                    Text("List")
                }
                .tag(0)
            
            GraphsView()
                .tabItem {
                    if selection == 0 {
                        Image("")
                    } else {
                        Image("")
                    }
                    Text("Overview")
                }
                .tag(0)
            
            BanksView()
                .tabItem {
                    if selection == 0 {
                        Image("")
                    } else {
                        Image("")
                    }
                    Text("My Banks")
                }
                .tag(0)
        }
    }
}
