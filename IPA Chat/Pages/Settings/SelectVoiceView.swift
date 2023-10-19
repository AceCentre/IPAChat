import SwiftUI
import AVFAudio

struct SelectVoiceView<ViewModel>: View where ViewModel: SettingsViewModel {
    @ObservedObject var viewModel: ViewModel
    @Binding var selectedLanguage: String
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedVoice: AVSpeechSynthesisVoice?
    
    var body: some View {
        NavigationView {
            List {
                let selectedVoiceTitle = viewModel.audioManager.selectedVoice?.name ?? "Not selected"
                HStack {
                    Text("Selected Voice:")
                        .font(.title3)
                        .foregroundStyle(.blue)
                    Spacer()
                    Text(selectedVoiceTitle)
                        .font(.title3)
                }
                
                ForEach(viewModel.groupedVoices.keys.sorted(), id: \.self) { language in
                    Section(header: Text(language)) {
                        if let voices = viewModel.groupedVoices[language] {
                            ForEach(voices, id: \.self) { wrapper in
                                Button(action: {
                                    viewModel.audioManager.selectedVoice = wrapper.voice
                                    selectedVoice = wrapper.voice
                                }) {
                                    HStack {
                                        Text(wrapper.voice.name)
                                        Spacer()
                                        if selectedVoice == wrapper.voice {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear(perform: {
                selectedVoice = viewModel.audioManager.selectedVoice
            })
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Voice")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

// MARK: - Previews
struct SelectVoiceView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SettingsViewModelImplementation(audioManager: AudioManager())
        
        @State var selectedLanguage = "EN"

        return SelectVoiceView(viewModel: viewModel, selectedLanguage: $selectedLanguage)
    }
}
