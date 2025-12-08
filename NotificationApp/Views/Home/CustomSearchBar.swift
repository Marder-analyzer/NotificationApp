//
//  CustomSearchBar.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI

struct CustomSearchBar: View {
    
    // MARK: - Değişkenler
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.hexConverter(hexString: "#8e8e93"))
            
            TextField("Bildirimlerde ara...", text: $text)
                .foregroundColor(.white)
                .accentColor(.white)
                .onAppear {
                    UITextField.appearance().attributedPlaceholder = NSAttributedString(
                        string: "Bildirimlerde ara...",
                        attributes: [NSAttributedString.Key.foregroundColor: UIColor(Color.hexConverter(hexString: "#8e8e93"))]
                    )
                }
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.hexConverter(hexString: "#8e8e93"))
                }
            }
        }
        .padding(10)
        .background(Color.hexConverter(hexString:"#1c2630"))
        .cornerRadius(15)
    }
}

#Preview {
    CustomSearchBar(text: .constant(""))
}
