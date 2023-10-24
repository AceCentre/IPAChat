import SwiftUI

struct ContentSearchView<ViewModel>: View where ViewModel: ContentViewModel {
    @ObservedObject var viewModel: ViewModel
    @Binding var showingSearchSheet: Bool
    
    var body: some View {
        VStack {
            Text("content.search.title".localized)
            TextField("content.search.text".localized, text: $viewModel.searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: viewModel.searchQuery) { oldValue, newValue in
                    if oldValue.contains(" ") {
                        viewModel.searchQuery = newValue.components(separatedBy: " ").joined()
                    }
                }
                .overlay(
                    Button(action: {
                        viewModel.searchQuery = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .opacity(viewModel.searchQuery.isEmpty ? 0 : 1).padding()
                    }
                        .padding(),
                    alignment: .trailing
                )
            Button("content.search.button.title") {
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
