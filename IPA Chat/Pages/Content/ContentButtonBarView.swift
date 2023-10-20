import SwiftUI

struct ContentButtonBarView<ViewModel>: View where ViewModel: ContentViewModel {
    @ObservedObject var viewModel: ViewModel
    
    @Binding var showingSearchSheet: Bool

    var body: some View {
        HStack {
            // Left-aligned buttons (Speak and Clear)
            Button(action: {
                viewModel.audioManager.speakCurrentSequence()
            }) {
                Image(systemName: "speaker.2.fill")
            }
            .padding()
            
            Button(action: {
                viewModel.audioManager.clearSequence()
            }) {
                Image(systemName: "xmark.circle.fill")
            }
            .padding()
            
            Spacer() // Pushes the buttons to the opposite ends
            
            // Right-aligned buttons (Babble Mode and Settings)
            Button(action: {
                self.showingSearchSheet = true
            }) {
                Image(systemName: "magnifyingglass.circle.fill")
            }
            .padding()
            Button(action: {
                viewModel.audioManager.toggleButton()
            }) {
                Image(systemName: "ellipsis.circle.fill")
                    .foregroundColor(viewModel.audioManager.isBabbleModeOn ? .green : .gray)
            }
            .padding()
            
            NavigationLink(destination: prepareSettingsView()) {
                Image(systemName: "gearshape.fill")
            }
            .padding()
        }
    }
    
    private func prepareSettingsView() -> some View {
        let cache = SpeechCacheImplementation()
        let vm = SettingsViewModelImplementation(cache: cache, audioManager: viewModel.audioManager)
        
        let view = SettingsView(
            viewModel: vm,
            selectedLanguage: $viewModel.selectedLanguage,
            phonemes: $viewModel.phonemes)
        
        return view
    }
}

// MARK: - Previews
struct ContentButtonBarView_Previews: PreviewProvider {
    static var previews: some View {
        let cache = PhonemesCacheImplementation()
        let audio = AudioManager()
        let vm = ContentViewModelImplementation(cache: cache, audioManager: audio)
        @State var showingSearchSheet = false
        ContentButtonBarView(viewModel: vm, showingSearchSheet: $showingSearchSheet)
    }
}
