import Foundation
import Combine
import AVFAudio
import PhonemesDB

// MARK: - SettingsViewModel Protocol
protocol SettingsViewModel: ObservableObject {
    var speechCache: SpeechCache { get }
    var selectedLanguageCache: SelectedLanguageCache { get }
    var phonemesCache: PhonemesCache { get }
    var audioManager: AudioManager { get set }
    var languages: [PhonemesDB] { get }
    var groupedVoices: [String: [VoiceWrapper]] { get }
    var pitch: Float { get set }
    var rate: Float { get set }
    var selectedVoice: AVSpeechSynthesisVoice? { get set }
    var shouldShowRequestPersonalVoiceAuthorization: Bool { get set }
    var selectedLanguage: PhonemesDB { get set }
}


// MARK: - SettingsViewModel Implementation
final class SettingsViewModelImplementation: SettingsViewModel {
    var speechCache: SpeechCache
    var selectedLanguageCache: SelectedLanguageCache
    var phonemesCache: PhonemesCache
    
    @Published var audioManager: AudioManager
    @Published var languages = [PhonemesDB.english_GB]
    @Published var groupedVoices: [String: [VoiceWrapper]] = ["": []]
    @Published var sampleTextToSpeak: String = ""
    @Published var shouldShowRequestPersonalVoiceAuthorization: Bool = false
    @Published var selectedLanguage: PhonemesDB = PhonemesDB.english_GB {
        didSet {
            onLanguageChange(selectedLanguage)
        }
    }
    
    @Published var pitch: Float = 1.0 {
        didSet {
            onPichChange(pitch)
        }
    }
    @Published var rate: Float = 1.0 {
        didSet {
            onRateChange(rate)
        }
    }
    @Published var selectedVoice: AVSpeechSynthesisVoice? {
        didSet {
            if let selectedVoice {
                onVoiceChange(selectedVoice)
            }
        }
    }
    
    init(
        speechCache: SpeechCache,
        audioManager: AudioManager,
        selectedLanguageCache: SelectedLanguageCache,
        phonemesCache: PhonemesCache) {
            self.speechCache = speechCache
            self.audioManager = audioManager
            self.selectedLanguageCache = selectedLanguageCache
            self.phonemesCache = phonemesCache
            self.selectedLanguage = selectedLanguageCache.get() ?? .english_GB
            
#if DEBUG
            groupedVoices = SortVoices.sortByLanguage()
#else
            requestPersonalVoiceAuth()
#endif
            
            self.languages = PhonemesDB.allCases
            loadRateCache()
            loadPitchCache()
            loadLanguageCache()
        }
    
    private func requestPersonalVoiceAuth() {
        AVSpeechSynthesizer.requestPersonalVoiceAuthorization { [weak self] status in
            switch status {
            case .notDetermined, .denied, .unsupported:
                self?.shouldShowRequestPersonalVoiceAuthorization = true
            case .authorized:
                self?.groupedVoices = SortVoices.sortByLanguage()
            @unknown default:
                break
            }
        }
    }
    
    private func loadRateCache() {
        let rateCache = speechCache.get(for: SpeechCacheType<Float>.Keys.rate)
        switch rateCache {
        case .value(let rate):
            if let rateValue = rate {
                self.rate = rateValue
            } else {
                print("Rate is nil")
            }
        }
    }
    
    private func loadPitchCache() {
        let pitchCache = speechCache.get(for: SpeechCacheType<Float>.Keys.pitch)
        switch pitchCache {
        case .value(let pitch):
            if let pitchValue = pitch {
                self.pitch = pitchValue
            } else {
                print("Pitch is nil")
            }
        }
    }
    
    private func loadLanguageCache() {
        let languageCache = speechCache.get(for: SpeechCacheType<String>.Keys.languageIdentifier)
        switch languageCache {
        case .value(let language):
            if let languageValue = language {
                self.selectedVoice = AVSpeechSynthesisVoice(identifier: languageValue)
            } else {
                print("Language is nil")
            }
        }
    }
}

// MARK: - User Actions
extension SettingsViewModelImplementation {
    private func onPichChange(_ pitch: Float) {
        speechCache.set(pitch, key: SpeechCacheType.Keys.pitch)
    }
    
    private func onRateChange(_ rate: Float) {
        speechCache.set(rate, key: SpeechCacheType.Keys.rate)
    }
    
    private func onVoiceChange(_ voice: AVSpeechSynthesisVoice) {
        speechCache.set(voice.identifier, key: SpeechCacheType.Keys.languageIdentifier)
    }
    
    private func onLanguageChange(_ language: PhonemesDB) {
        print("Language changed to: \(String(describing: language))")
        
        selectedLanguageCache.set(language)
        
        let selectedPhonemes = language.get
        phonemesCache.set(selectedPhonemes)
    }
}
