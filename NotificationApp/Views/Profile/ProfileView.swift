//
//  ProfileView.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 24.12.2025.
//
import SwiftUI

struct ProfileView: View {
	@EnvironmentObject var authCoordinator: AuthCoordinator
	
	var body: some View {
		ZStack {
			Color.hexConverter(hexString: "#13181f")
				.ignoresSafeArea()
			VStack {
				
				AsyncImage(url: URL(string: "https://www.pngall.com/wp-content/uploads/5/Profile-Male-PNG.png")) { phase in
					switch phase {
					case .success(let image):
						image
							.resizable()
							.frame(width: 100, height: 100)
							.ignoresSafeArea()
							
					default:
						Color.black.ignoresSafeArea()
					}
				}
				Text("Safiyenur Özer")
					.font(.title)
					.foregroundStyle(.white)
					.padding()
				
				rowMaker(icon: "xmark", title: "E-Posta", description: "safiyenurOzer@gmail.com")
				
				rowMaker(icon: "xmark", title: "Kullanıcı Rolü", description: "Yönetici")
				
				rowMaker(icon: "xmark", title: "Birim", description: "İnsan Kaynakları")
			}
		}
		
	}
	
	@ViewBuilder
	func rowMaker(
		icon: String,
		title: String,
		description: String
	) -> some View {
		HStack {
			Image(systemName: icon)
				.foregroundStyle(.white)
			Text(title)
				.foregroundStyle(.white)
			
			Spacer()
			
			Text(description)
				.foregroundStyle(.gray)
			
		}.padding(.horizontal, 20)
			.padding(.vertical)
			.overlay {
				VStack {
					Spacer()
					Rectangle().frame(height: 0.5)
						.foregroundStyle(.gray).opacity(0.3)
						.padding(.horizontal, 5)
				}
			}
	}
}

#Preview {
	ProfileView()
}
