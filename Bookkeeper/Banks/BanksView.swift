import SwiftUI

struct BanksView: View {
    @ObservedObject var viewModel: BanksViewModel
    
    var body: some View {
        VStack {
            ForEach($viewModel.savedBanks, id: \.self) { bank in
                //Button
            }

            //Button
        }
    }
}
