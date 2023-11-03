import SwiftUI
import AVFAudio
import PhonemesDB

struct SettingsView<ViewModel>: View where ViewModel: SettingsViewModel {
    @ObservedObject var viewModel: ViewModel
    //@Binding var selectedLanguage: String
    @Binding var phonemes: [Phoneme]
    
    @State private var selectedSection: SettingsSectionType?
    @State private var isPresented = false
    
    let sectionButtons: [SettingsSectionButton] = [
        SettingsSectionButton(title: "settings.section.button.language".localized, sectionType: .language),
        SettingsSectionButton(title: "settings.section.button.voices".localized, sectionType: .selectVoice),
        SettingsSectionButton(title: "settings.section.button.reorder".localized, sectionType: .reorderPhonemes)
    ]
    
    var body: some View {
        NavigationStack {
            List(sectionButtons, id: \.self) { button in
                Button(action: {
                    selectedSection = button.sectionType
                    isPresented = true
                }) {
                    HStack {
                        Text(button.title)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                .sheet(isPresented: $isPresented) {
                    self.destinationView(for: selectedSection!)
                }
            }
        }
        .navigationTitle("settings.navigation.title".localized)
    }
}

// MARK: - Destination Views
extension SettingsView {
    private func destinationView(for section: SettingsSectionType) -> some View {
        switch section {
        case .language:
            return AnyView(LanguageView(viewModel: viewModel))
        case .selectVoice:
            return AnyView(VoicesView(viewModel: viewModel))
        case .reorderPhonemes:
            return AnyView(PhonemesView(viewModel: viewModel, phonemes: $phonemes))
        }
    }
}

// MARK: - Previews
struct SettingsView_Previews: PreviewProvider {
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
        
        @State var phonemes = [
            Phoneme(
                symbol: "test",
                ipaNotation: "test",
                type: .nasal)]
        
        SettingsView(
            viewModel: vm,
            phonemes: $phonemes)
    }
}
