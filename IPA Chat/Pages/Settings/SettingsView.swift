import SwiftUI
import AVFAudio

struct SettingsView<ViewModel>: View where ViewModel: SettingsViewModel {
    @ObservedObject var viewModel: ViewModel
    @Binding var selectedLanguage: String
    @Binding var phonemes: [Phoneme]
    
    @State private var selectedSection: SettingsSectionType?
    @State private var isPresented = false
    
    let sectionButtons: [SettingsSectionButton] = [
        SettingsSectionButton(title: "Language", sectionType: .language),
        SettingsSectionButton(title: "Select Voice", sectionType: .selectVoice),
        SettingsSectionButton(title: "Reorder Phonemes", sectionType: .reorderPhonemes)
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
        .navigationTitle("Settings")
    }
}

// MARK: - Destination Views
extension SettingsView {
    private func destinationView(for section: SettingsSectionType) -> some View {
        switch section {
        case .language:
            return AnyView(LanguageView(viewModel: viewModel, selectedLanguage: $selectedLanguage))
        case .selectVoice:
            return AnyView(SelectVoiceView(viewModel: viewModel, selectedLanguage: $selectedLanguage))
        case .reorderPhonemes:
            return AnyView(PhonemesView(viewModel: viewModel, phonemes: $phonemes))
        }
    }
}

// MARK: - Previews
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = SettingsViewModelImplementation(audioManager: AudioManager())
        @State var selectedLanguage = "test language"
        @State var phonemes = [Phoneme(symbol: "test", ipaNotation: "test", type: .nasal)]
        
        SettingsView(
            viewModel: vm,
            selectedLanguage: $selectedLanguage,
            phonemes: $phonemes)
    }
}
