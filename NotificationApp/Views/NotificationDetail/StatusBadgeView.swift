//
//  StatusBadgeView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 5.12.2025.
//

import SwiftUI

struct StatusBadgeView: View {
    @State var status: NotificationStatus
    let role: String
    
    var body: some View {
        if role == "Admin" {
            Menu {
                ForEach(NotificationStatus.allCases, id: \.self) { option in
                    Button {
                        withAnimation {
                            self.status = option
                        }
                    } label: {
                        HStack {
                            Text(option.rawValue)
                            if status == option {
                                Image(systemName: "pencil")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(status.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.vertical, 8)
                        .padding(.leading, 20)
                        .foregroundColor(status.color)
                        
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .padding(.trailing, 20)
                        .tint(status.color)
                }
                .background(status.color.opacity(0.1))
                .clipShape(.rect(cornerRadius: 35))
                
            }
        }
        else {
            Text(status.rawValue)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .background(status.color.opacity(0.1))
                .foregroundColor(status.color)
                .clipShape(.rect(cornerRadius: 35))
        }
    }
}

#Preview {
    StatusBadgeView(status: .open, role: "Admin")
}
