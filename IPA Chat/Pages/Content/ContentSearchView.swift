import SwiftUI

struct ContentSearchView<ViewModel>: View where ViewModel: ContentViewModel {
    @ObservedObject var viewModel: ViewModel
    @Binding var showingSearchSheet: Bool

    var body: some View {
        VStack {
            Text("Search for a word")
            TextField("Enter the word to find its IPA form.", text: $viewModel.searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Search") {
                viewModel.didTapSearch()
                showingSearchSheet = false
            }
            .padding()
        }
        .padding()
    }
}

// MARK: - Previews
struct ContentSearchView_Previews: PreviewProvider {
    static var previews: some View {
        @State var showingSearchSheet = false
        let cache = PhonemesCacheImplementation()
        let vm = ContentViewModelImplementation(cache: cache, audioManager: AudioManager())
        ContentSearchView(viewModel: vm, showingSearchSheet: $showingSearchSheet)
    }
}
