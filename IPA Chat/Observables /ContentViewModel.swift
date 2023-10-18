import Foundation
import Combine

// MARK: - ContentViewModel Protocol
protocol ContentViewModel: ObservableObject {
    var phonemes: [Phoneme] { get set }
    var selectedLanguage: String { get set }
    var searchQuery: String { get set }
    var audioManager: AudioManager { get set }
    var ipaResult: String? { get }
    func didTapSearch()
}


// MARK: - ContentViewModel Implementation
final class ContentViewModelImplementation: ContentViewModel {
    @Published var phonemes: [Phoneme] = Phonemes.english
    @Published var selectedLanguage: String = "English-GB" {
        didSet {
            onPhonemeChange(selectedLanguage)
        }
    }
    @Published var searchQuery: String = ""
    @Published var ipaResult: String? = nil
    @Published var audioManager: AudioManager

    init(audioManager: AudioManager) {
        self.audioManager = audioManager
        loadPhonemes()
    }
}

// MARK: - User Actions
extension ContentViewModelImplementation {
    func onPhonemeChange(_ phoneme: String) {
        print("Language changed to: \(String(describing: phoneme))")
        switch phoneme {
        case "English-GB":
            self.phonemes = Phonemes.english
        case "French":
            self.phonemes = Phonemes.french
        default:
            print("Unknown language")
        }
    }
    
    func didTapSearch() {
        let lowercasedQuery = searchQuery.lowercased()
        if let ipaForm = audioManager.getPhonemeForString(selectedLanguage: selectedLanguage, searchString: lowercasedQuery) {
            self.ipaResult = "IPA Result: \(ipaForm)"
        } else {
            self.ipaResult = "No IPA form found"
        }
    }
}

// MARK: - Phonemes handling
extension ContentViewModelImplementation {
    func savePhonemes() {
        if let encoded = try? JSONEncoder().encode(phonemes) {
            UserDefaults.standard.set(encoded, forKey: "phonemes")
        }
    }
    
    func loadPhonemes() {
        if let savedPhonemes = UserDefaults.standard.object(forKey: "phonemes") as? Data,
           let decodedPhonemes = try? JSONDecoder().decode([Phoneme].self, from: savedPhonemes) {
            self.phonemes = decodedPhonemes
        }
    }
}
