import SwiftUI
import AVFAudio

struct SelectedVoiceView<ViewModel, Audio>: View where ViewModel: SettingsViewModel, Audio: AudioManager {
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var audioManager: Audio
    @State private var isPlayingSample = false
    @State private var isPresented = false
    private let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            VStack {
                let selectedVoiceTitle = viewModel.selectedVoice?.name ?? "settings.selected.voice.not.selected".localized
                HStack {
                    Text("settings.selected.voice.header.title".localized)
                    Spacer()
                    Text(selectedVoiceTitle)
                    Image(systemName: "chevron.right")
                }
                .onTapGesture {
                    self.isPresented = true
                }
            }
            Divider()
            VStack {
                let selectedVoiceTitle = viewModel.selectedLanguage.name.localized
                HStack {
                    Text("settings.selected.language.header.title".localized)
                    Spacer()
                    Text(selectedVoiceTitle)
                }
            }
            Divider()
            VStack {
                Button(action: {
                    isPlayingSample.toggle()
                    if isPlayingSample {
                        if let voice = viewModel.selectedVoice {
                            let textToSpeak = "settings.sample.text.to.speak".localized
                            audioManager.phonemeString = NSMutableAttributedString(string: textToSpeak)
                            audioManager.selectedVoice = voice
                            audioManager.speakCurrentSequence()
                        }
                    } else {
                        audioManager.clearSequence()
                    }
                }) {
                    HStack {
                        Image(systemName: isPlayingSample ? "stop.circle" : "play.circle")
                        Text(isPlayingSample ? "settings.selected.voice.stop.sample".localized : "settings.selected.voice.play.sample".localized)
                        Spacer()
                    }
                    
                }
            }
            Divider()
            VStack {
                HStack {
                    Text("settings.selected.voice.play.pitch".localized)
                    Slider(value: $viewModel.pitch, in: 0.5...2.0, step: 0.1)
                    Text(String(format: "%.1f", viewModel.pitch))
                }
                Divider()
                HStack {
                    Text("settings.selected.voice.play.rate".localized)
                    Slider(value: $viewModel.rate, in: 0.1...2.0, step: 0.1)
                    Text(String(format: "%.1f", viewModel.rate))
                }
            }
            .sheet(isPresented: $isPresented) {
                VoiceByLanguageView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Previews
struct SelectedVoiceView_Previews: PreviewProvider {
    static var previews: some View {
        let speechCache = MockSpeechCache(userDefaults: MockUserDefaults())
        let phonemesCache = MockPhonemesCache()
        let selectedLanguageCache = MockSelectedLanguageCache()
        let audioManager = MockAudioManager()
        
        let vm = MockSettingsViewModel(
            speechCache: speechCache,
            selectedLanguageCache: selectedLanguageCache,
            phonemesCache: phonemesCache,
            audioManager: audioManager)
        
        return SelectedVoiceView(viewModel: vm, audioManager: audioManager)
    }
}
