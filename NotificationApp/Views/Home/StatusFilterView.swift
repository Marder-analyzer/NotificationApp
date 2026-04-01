//
//  StatusFilterView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI

struct StatusFilterView: View {
    // MARK: - Değişkenler
    @Binding var selectedIndex: Int
    let options: [String]
    
    init(selectedIndex: Binding<Int>, options: [String]) {
        self._selectedIndex = selectedIndex
        self.options = options
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemBlue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.hexConverter(hexString: "#8e8e93"))], for: .normal)
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.hexConverter(hexString:"#1c2630"))
    }
    
    
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
