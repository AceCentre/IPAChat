import SwiftUI
import AVFAudio
import PhonemesDB

struct SettingsView<ViewModel>: View where ViewModel: SettingsViewModel {
    @ObservedObject var viewModel: ViewModel
    @Binding var phonemes: [Phoneme]
    
    @State private var showLanguageView = false
    @State private var showVoicesView = false
    @State private var showReorderPhonemesView = false
    
    let sectionButtons: [SettingsSectionButton] = [
        SettingsSectionButton(title: "settings.section.button.language".localized, sectionType: .language),
        SettingsSectionButton(title: "settings.section.button.voices".localized, sectionType: .selectVoice),
        SettingsSectionButton(title: "settings.section.button.reorder".localized, sectionType: .reorderPhonemes)
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Button(action: {
                    showLanguageView = true
                }) {
                    HStack {
                        Text("settings.section.button.language".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                .sheet(isPresented: $showLanguageView) {
                    LanguageView(viewModel: viewModel)
                }

                Button(action: {
                    showVoicesView = true
                }) {
                    HStack {
                        Text("settings.section.button.voices".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                .sheet(isPresented: $showVoicesView) {
                    VoicesView(viewModel: viewModel)
                }

                Button(action: {
                    showReorderPhonemesView = true
                }) {
                    HStack {
                        Text("settings.section.button.reorder".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                .sheet(isPresented: $showReorderPhonemesView) {
                    PhonemesView(viewModel: viewModel)
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
            return AnyView(PhonemesView(viewModel: viewModel))
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
