import Foundation
import PhonemesDB

class MockContentViewModel: ContentViewModel {
    var phonemesCache: PhonemesCache
    var selectedLanguageCache: SelectedLanguageCache
    @Published var phonemes: [Phoneme] = []
    @Published var searchQuery: String = ""
    @Published var ipaResult: String?
    @Published var ipaTitle: String?
    var audioManager: AudioManager

    init(phonemesCache: PhonemesCache, audioManager: AudioManager, selectedLanguageCache: SelectedLanguageCache) {
        self.phonemesCache = phonemesCache
        self.audioManager = audioManager
        self.selectedLanguageCache = selectedLanguageCache
    }

    func didTapSearch() {
        if searchQuery == "mockQuery" {
            ipaResult = "mockIPA"
            ipaTitle = "Mock Result"
        } else {
            ipaResult = nil
            ipaTitle = "No Result"
        }
    }

    func viewDidAppear() {
        phonemes = [Phoneme(symbol: "a", ipaNotation: "a", type: .consonant)]
    }
}
