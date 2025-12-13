//
//  AdminEditDescriptionView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 13.12.2025.
//

import SwiftUI

struct AdminEditDescriptionView: View {
    @Environment(\.dismiss) var dismiss
    @State var description: String
    var onSave: (String) -> Void
    
    var body: some View {
        ZStack {
            Color.hexConverter(hexString: "#13181f")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                customHeader
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Açıklamayı Düzenle")
                        .foregroundStyle(.white)
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 4)
                    
                    TextEditor(text: $description)
                        .scrollContentBackground(.hidden)
                        .padding(12)
                        .background(Color.hexConverter(hexString: "#1c2630"))
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 20)
        }
    }
    
    private var customHeader: some View {
        HStack {
            Button("İptal") {
                dismiss()
            }
            .foregroundColor(.gray)
            
            Spacer()
            
            Text("İçerik Düzenleme")
                .foregroundStyle(.white)
                .font(.headline)
                .bold()
            
            Spacer()
            
            Button("Kaydet") {
                onSave(description)
                dismiss()
            }
            .foregroundColor(.blue)
            .bold()
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

#Preview {
    AdminEditDescriptionView(description: "", onSave: {_ in
        
    })
}
