//
//  StatusFilterView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct StatusFilterView: View {
    // MARK: - Değişkenler
    @Binding var selectedIndex: Int
    let options: [String]
    
    var body: some View {
        Picker("Durum", selection: $selectedIndex) {
            ForEach(0..<options.count, id: \.self) { index in
                Text(options[index]).tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

#Preview {
    StatusFilterView(
        selectedIndex: .constant(0),
        options: ["Tümü", "Açık", "İnceleniyor", "Çözüldü"]
    )
    .padding()
}
