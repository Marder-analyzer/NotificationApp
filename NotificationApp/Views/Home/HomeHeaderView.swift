//
//  HomeHeaderView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct HomeHeaderView: View {
    // MARK: - Değişkenler
    var onAddTapped: () -> Void
    
    var body: some View {
        ZStack {
            Text("Ana Sayfa")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                Spacer()
                Button(action: onAddTapped) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

#Preview {
    HomeHeaderView(onAddTapped: {
        print("Tıklandı")
    })
}
