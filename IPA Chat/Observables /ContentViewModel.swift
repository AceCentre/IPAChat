import Foundation
import Combine
import PhonemesDB

// MARK: - ContentViewModel Protocol
protocol ContentViewModel: ObservableObject {
    var phonemesCache: PhonemesCache { get set }
    var selectedLanguageCache: SelectedLanguageCache { get }
    var phonemes: [Phoneme] { get set }
    var searchQuery: String { get set }
    var audioManager: AudioManager { get set }
    var ipaResult: String? { get }
    var ipaTitle: String? { get }
    func didTapSearch()
    func viewDidAppear()
}


// MARK: - ContentViewModel Implementation
final class ContentViewModelImplementation: ContentViewModel {
    var phonemesCache: PhonemesCache
    var selectedLanguageCache: SelectedLanguageCache
    @Published var phonemes: [Phoneme] = PhonemesDB.english_GB.get
    @Published var searchQuery: String = ""
    @Published var ipaResult: String? = nil
    @Published var ipaTitle: String? = nil
    var audioManager: AudioManager
    
    init(
        phonemesCache: PhonemesCache,
        audioManager: AudioManager,
        selectedLanguageCache: SelectedLanguageCache) {
            self.phonemesCache = phonemesCache
            self.audioManager = audioManager
            self.selectedLanguageCache = selectedLanguageCache
            loadPhonemes()
        }
    
    func viewDidAppear() {
        loadPhonemes()
    }
}

// MARK: - User Actions
extension ContentViewModelImplementation {
    func didTapSearch() {
        let lowercasedQuery = searchQuery.lowercased()
        guard let selectedLanguage = selectedLanguageCache.get()?.name.localized else { return }
        
        if let ipaForm = audioManager.getPhonemeForString(
            selectedLanguage: selectedLanguage,
            searchString: lowercasedQuery) {
            let fixedForm = ipaForm.replacingOccurrences(of: "/", with: "")
            self.ipaResult = fixedForm
            self.ipaTitle = "content.ipa.result.title".localized
        } else {
            self.ipaTitle = "content.ipa.result.error".localized
        }
    }
}

// MARK: - Phonemes handling
extension ContentViewModelImplementation {
    func savePhonemes() {
        phonemesCache.set(phonemes)
    }
    
    func loadPhonemes() {
        guard let savedPhonemes = phonemesCache.get() else {
            print("Cant' get saved Phonemes!")
            return
        }
        self.phonemes = savedPhonemes
    }
}
