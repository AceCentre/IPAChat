import SwiftUI
import AVFAudio

struct SelectedVoiceView<ViewModel>: View where ViewModel: SettingsViewModel {
    @ObservedObject var viewModel: ViewModel
    
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
                Button(action: {
                    // Play sample of the selected voice
                    if let voice = viewModel.selectedVoice {
                        let textToSpeak = "settings.sample.text.to.speak".localized
                        let utterance = AVSpeechUtterance(string: textToSpeak)
                        utterance.voice = voice
                        utterance.pitchMultiplier = Float(viewModel.pitch)
                        utterance.rate = Float(viewModel.rate)
                        AVSpeechSynthesizer().speak(utterance)
                    }
                }) {
                    HStack {
                        Image(systemName: "play.circle")
                        Text("settings.selected.voice.play.sample".localized)
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

        return SelectedVoiceView(viewModel: vm)
    }
}
