import SwiftUI
import PhonemesDB

struct ContentPhonemeButtonView<ViewModel, Audio>: View where ViewModel: ContentViewModel, Audio: AudioManager {
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var audioManager: Audio
    let phoneme: Phoneme

    var body: some View {
        Button(action: {
            audioManager.appendPhoneme(phoneme)
        }) {
            Text(phoneme.symbol)
                .frame(width: 70, height: 70)
                .background(phoneme.color)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .offset(x: phoneme.x, y: phoneme.y)
    }
}

// MARK: - Previews
struct ContentPhonemeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        let audioManager = AudioManager()
        let phonemesCache = PhonemesCacheImplementation()
        let selectedLanguageCache = SelectedLanguageCacheImplementation()
        
        let vm = ContentViewModelImplementation(
            phonemesCache: phonemesCache,
            audioManager: audioManager,
            selectedLanguageCache: selectedLanguageCache)
        
        let phoneme = Phoneme(symbol: "test", ipaNotation: "test", type: .nasal)
        ContentPhonemeButtonView(viewModel: vm, audioManager: audioManager, phoneme: phoneme)
    }
}
