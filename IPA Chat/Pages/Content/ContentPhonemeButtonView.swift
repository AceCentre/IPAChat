import SwiftUI
import PhonemesDB

struct ContentPhonemeButtonView<ViewModel, Audio>: View where ViewModel: ContentViewModel, Audio: AudioManager {
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var audioManager: Audio
    @ObservedObject var observablePhoneme: ObservablePhoneme

    var body: some View {
        Button(action: {
            audioManager.appendPhoneme(observablePhoneme.phoneme)
        }) {
            ZStack {
                if let customImage = observablePhoneme.customImage {
                    Image(uiImage: customImage)
                        .resizable()
                        .scaledToFit()
                } else if let customText = observablePhoneme.customText {
                    Text(customText)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                } else {
                    Text(observablePhoneme.phoneme.symbol)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 70, height: 70)
            .background(observablePhoneme.color)
            .cornerRadius(10)
        }
        .offset(x: observablePhoneme.phoneme.x, y: observablePhoneme.phoneme.y)
    }
}

// MARK: - Previews
struct ContentPhonemeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        let phoneme = Phoneme(
            symbol: "test",
            ipaNotation: "test",
            type: .nasal
        )
        
        let observablePhoneme = ObservablePhoneme(phoneme: phoneme)
        
        let phonemesCache = MockPhonemesCache()
        let audioManager = MockAudioManager()
        let selectedLanguageCache = MockSelectedLanguageCache()
        
        let viewModel = MockContentViewModel(
            phonemesCache: phonemesCache,
            audioManager: audioManager,
            selectedLanguageCache: selectedLanguageCache
        )
        
        return ContentPhonemeButtonView(
            viewModel: viewModel,
            audioManager: audioManager,
            observablePhoneme: observablePhoneme
        )
    }
}

