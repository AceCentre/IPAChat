import Foundation
import Combine
import PhonemesDB

// MARK: - ContentViewModel Protocol
protocol ContentViewModel: ObservableObject {
    var cache: PhonemesCache { get set }
    var phonemes: [Phoneme] { get set }
    var selectedLanguage: String { get set }
    var searchQuery: String { get set }
    var audioManager: AudioManager { get set }
    var ipaResult: String? { get }
    var ipaTitle: String? { get }
    func didTapSearch()
}


// MARK: - ContentViewModel Implementation
final class ContentViewModelImplementation: ContentViewModel {
    var cache: PhonemesCache
    @Published var phonemes: [Phoneme] = PhonemesDB.english_GB.get
    @Published var selectedLanguage: String = PhonemesDB.english_GB.rawValue {
        didSet {
            onPhonemeChange(selectedLanguage)
        }
    }
    @Published var searchQuery: String = ""
    @Published var ipaResult: String? = nil
    @Published var ipaTitle: String? = nil
    var audioManager: AudioManager
    
    init(cache: PhonemesCache, audioManager: AudioManager) {
        self.cache = cache
        self.audioManager = audioManager
        loadPhonemes()
    }
}

// MARK: - User Actions
extension ContentViewModelImplementation {
    func onPhonemeChange(_ phoneme: String) {
        print("Language changed to: \(String(describing: phoneme))")
        
        guard let selectedPhoneme = PhonemesDB(rawValue: phoneme) else { return }
        self.phonemes = selectedPhoneme.get
    }
    
    func didTapSearch() {
        let lowercasedQuery = searchQuery.lowercased()
        if let ipaForm = audioManager.getPhonemeForString(selectedLanguage: selectedLanguage, searchString: lowercasedQuery) {
            var fixedForm = ipaForm.replacingOccurrences(of: "/", with: "")
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
        cache.set(phonemes)
    }
    
    func loadPhonemes() {
        guard let savedPhonemes = cache.get() else {
            print("Cant' get saved Phonemes!")
            return
        }
        self.phonemes = savedPhonemes
    }
}
