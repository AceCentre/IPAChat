//
//  IPA_ChatApp.swift
//  IPA Chat
//
//  Created by Will Wade on 17/10/2023.
//

import SwiftUI

@main
struct IPA_ChatApp: App {
    @StateObject var voiceEngine: VoiceEngine = VoiceEngine()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(voiceEngine)
                .onAppear {
                    voiceEngine.load()
                }
                .onDisappear {
                    voiceEngine.save()
                }

        }
    }
}
