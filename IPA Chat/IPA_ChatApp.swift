//
//  IPA_ChatApp.swift
//  IPA Chat
//
//  Created by Will Wade on 17/10/2023.
//

import SwiftUI

@main
struct IPA_ChatApp: App {
    var body: some Scene {
        WindowGroup {
            let audioManager = AudioManager()
            let cache = PhonemesCacheImplementation()
            let viewModel = ContentViewModelImplementation(cache: cache, audioManager: audioManager)
            ContentView(viewModel: viewModel, audioManager: audioManager)
        }
    }
}
