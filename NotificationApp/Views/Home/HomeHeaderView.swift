//
//  HomeHeaderView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
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
                .foregroundStyle(.white)
            
            HStack {
                Spacer()
                Button(action: onAddTapped) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    HomeHeaderView(onAddTapped: {
        print("Tıklandı")
    })
}
