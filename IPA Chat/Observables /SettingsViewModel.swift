import Foundation
import Combine
import AVFAudio

// MARK: - SettingsViewModel Protocol
protocol SettingsViewModel: ObservableObject {
    var audioManager: AudioManager { get set }
    var languages: [String] { get }
    var groupedVoices: [String: [VoiceWrapper]] { get }
}


// MARK: - SettingsViewModel Implementation
final class SettingsViewModelImplementation: SettingsViewModel {
    @Published var audioManager: AudioManager
    @Published var languages = ["English-GB", "French"]
    @Published var groupedVoices: [String: [VoiceWrapper]]

    init(audioManager: AudioManager) {
        self.audioManager = audioManager
        self.groupedVoices = voicesByLanguage()
    }
}
