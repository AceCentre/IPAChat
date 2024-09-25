//
//  PhonemeCustomizationView.swift
//  IPA Chat
//
//  Created by Will Wade on 23/08/2024.
//

import Foundation
import SwiftUI

struct PhonemeCustomizationView: View {
    @Binding var observablePhoneme: ObservablePhoneme
    @State private var selectedColor: Color = .blue
    @State private var customText: String = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false

    var body: some View {
        Form {
            Section(header: Text("Customize Phoneme")) {
                ColorPicker("Select Color", selection: $selectedColor)
                    .onChange(of: selectedColor) { oldColor, newColor in
                        observablePhoneme.color = newColor
                    }
                
                TextField("Custom Text", text: $customText)
                    .onChange(of: customText) { oldText, newText in
                        observablePhoneme.customText = newText.isEmpty ? nil : newText
                    }
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    Text("Select Image")
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .onChange(of: selectedImage) {
                            observablePhoneme.customImage = selectedImage
                        }
                }
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .onChange(of: selectedImage) { oldImage, newImage in
                            observablePhoneme.customImage = newImage
                        }
                }
            }
        }
        .onAppear {
            selectedColor = observablePhoneme.color
            customText = observablePhoneme.customText ?? ""
        }
    }
}
