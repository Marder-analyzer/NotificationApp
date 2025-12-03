//
//  CustomSearchBar.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct CustomSearchBar: View {
    
    // MARK: - Değişkenler
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Bildirimlerde ara...", text: $text)
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    CustomSearchBar(text: .constant("Güvenlik"))
}
