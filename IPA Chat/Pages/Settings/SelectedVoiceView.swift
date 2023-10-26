import SwiftUI
import AVFAudio

struct SelectedVoiceView<ViewModel>: View where ViewModel: SettingsViewModel {
    @ObservedObject var viewModel: ViewModel
    @Binding var selectedLanguage: String
    @State private var isPlayingSample = false
    
    var body: some View {
        VStack {
            VStack {
                let selectedVoiceTitle = viewModel.selectedVoice?.name ?? "settings.selected.voice.not.selected".localized
                HStack {
                    Text("settings.selected.voice.header.title".localized)
                    Spacer()
                    Text(selectedVoiceTitle)
                }
            }
            Divider()
            VStack {
                let selectedVoiceTitle = selectedLanguage
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
                            let utterance = AVSpeechUtterance(string: textToSpeak)
                            utterance.voice = voice
                            utterance.pitchMultiplier = Float(viewModel.pitch)
                            utterance.rate = Float(viewModel.rate)
                            AVSpeechSynthesizer().speak(utterance)
                        }
                    } else {
                        AVSpeechSynthesizer().stopSpeaking(at: .immediate)
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
        }
    }
}

// MARK: - Previews
struct SelectedVoiceView_Previews: PreviewProvider {
    static var previews: some View {
        let cache = SpeechCacheImplementation()
        let vm = SettingsViewModelImplementation(cache: cache, audioManager: AudioManager())
        @State var selectedLanguage = "EN-GB"
        return SelectedVoiceView(viewModel: vm, selectedLanguage: $selectedLanguage)
    }
}