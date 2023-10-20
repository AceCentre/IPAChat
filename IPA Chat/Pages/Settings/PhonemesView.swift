import SwiftUI
import PhonemesDB

struct PhonemesView<ViewModel>: View where ViewModel: SettingsViewModel {
    @ObservedObject var viewModel: ViewModel
    @Binding var phonemes: [Phoneme]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Form {
                List {
                    ForEach(phonemes) { phoneme in
                        Text(phoneme.symbol)
                    }
                    .onMove(perform: move)
                }
            }
            .navigationTitle("settings.phonemes.navigation.title".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        // Move elements around
        phonemes.move(fromOffsets: source, toOffset: destination)
    }
}

// MARK: - Previews
struct PhonemesView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePhonemes: [Phoneme] = [
            Phoneme(symbol: "A", ipaNotation: "test", type: .nasal),
            Phoneme(symbol: "B", ipaNotation: "test", type: .nasal),
            Phoneme(symbol: "C", ipaNotation: "test", type: .nasal),
        ]
        
        let cache = SpeechCacheImplementation()
        let vm = SettingsViewModelImplementation(cache: cache, audioManager: AudioManager())
        
        return PhonemesView(viewModel: vm, phonemes: .constant(samplePhonemes))
    }
}
