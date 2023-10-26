import Foundation
import Combine
import AVFAudio
import PhonemesDB

// MARK: - SettingsViewModel Protocol
protocol SettingsViewModel: ObservableObject {
    var cache: SpeechCache { get }
    var audioManager: AudioManager { get set }
    var languages: [String] { get }
    var groupedVoices: [String: [VoiceWrapper]] { get }
    var pitch: Float { get set }
    var rate: Float { get set }
    var selectedVoice: AVSpeechSynthesisVoice? { get set }
    var shouldShowRequestPersonalVoiceAuthorization: Bool { get set }
}


// MARK: - SettingsViewModel Implementation
final class SettingsViewModelImplementation: SettingsViewModel {
    var cache: SpeechCache
    @Published var audioManager: AudioManager
    @Published var languages = [""]
    @Published var groupedVoices: [String: [VoiceWrapper]] = ["": []]
    @Published var sampleTextToSpeak: String = ""
    @Published var shouldShowRequestPersonalVoiceAuthorization: Bool = false
    
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

    init(cache: SpeechCache, audioManager: AudioManager) {
        self.cache = cache
        self.audioManager = audioManager
        
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
        
        self.languages = PhonemesDB.allCases.map { $0.rawValue }
        loadRateCache()
        loadPitchCache()
        loadLanguageCache()
    }
    
    private func loadRateCache() {
        let rateCache = cache.get(for: SpeechCacheType<Float>.Keys.rate)
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
        let pitchCache = cache.get(for: SpeechCacheType<Float>.Keys.pitch)
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
        let languageCache = cache.get(for: SpeechCacheType<String>.Keys.languageIdentifier)
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
        cache.set(pitch, key: SpeechCacheType.Keys.pitch)
    }
    
    private func onRateChange(_ rate: Float) {
        cache.set(rate, key: SpeechCacheType.Keys.rate)
    }
    
    private func onVoiceChange(_ voice: AVSpeechSynthesisVoice) {
        cache.set(voice.identifier, key: SpeechCacheType.Keys.languageIdentifier)
    }
}
