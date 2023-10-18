import SwiftUI

struct ContentPhonemeButtonView<ViewModel>: View where ViewModel: ContentViewModel {
    @ObservedObject var viewModel: ViewModel
    let phoneme: Phoneme

    var body: some View {
        Button(action: {
            viewModel.audioManager.appendPhoneme(phoneme)
        }) {
            Text(phoneme.symbol)
                .frame(width: 70, height: 70)
                .background(phoneme.color)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .offset(x: phoneme.x, y: phoneme.y)
    }
}

// MARK: - Previews
struct ContentPhonemeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ContentViewModelImplementation(audioManager: AudioManager())
        let phoneme = Phoneme(symbol: "test", ipaNotation: "test", type: .nasal)
        ContentPhonemeButtonView(viewModel: vm, phoneme: phoneme)
    }
}
