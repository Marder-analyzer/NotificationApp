//
//  ProfileView.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 24.12.2025.
//
import SwiftUI
import Firebase
import FirebaseAuth

struct ProfileView: View {
	@StateObject var authCoordinator = AuthCoordinator()
	@State private var profile: AuthUser?
	@StateObject var vm: GenericViewModel
	
	var body: some View {
		ZStack {
			Color.hexConverter(hexString: "#13181f")
				.ignoresSafeArea()
			
			if let user = profile {
				VStack(spacing: 12) {
					
					AsyncImage(
						url: URL(string: user.photoURL ??
										 "https://www.pngall.com/wp-content/uploads/5/Profile-Male-PNG.png")
					) { phase in
						switch phase {
						case .success(let image):
							image
								.resizable()
								.scaledToFill()
						default:
							Color.gray
						}
					}
					.frame(width: 100, height: 100)
					.clipShape(Circle())
					
					Text(user.fullName ?? "")
						.font(.title)
						.foregroundStyle(.white)
						.padding(.top, 8)
					
					rowMaker(
						icon: "envelope",
						title: "E-Posta",
						description: user.email ?? ""
					)
					
					rowMaker(
						icon: "person.crop.circle",
						title: "Kullanıcı Rolü",
						description: user.role == "admin" ? "Yönetici" : "Kullanıcı"
					)
					
					rowMaker(
						icon: "building.2",
						title: "Birim",
						description: user.department ?? ""
					)
                    
					if profile?.role != "admin" {
						NavigationLink {
							FollowingNotificationsView(repository: vm, profile: profile)
						} label: {
							rowMaker(
								icon: "building.2",
								title: "Bildirimler",
								description: "")
						}
					}

					Button {
						Task {
							try Auth.auth().signOut()
							NotificationCenter.default.post(name: .restartApp, object: nil)
						}
					} label: {
						Text("Çıkış Yap")
							.foregroundStyle(.white)
					}.frame(width: 250, height: 50)
						.background(.red)
						.clipShape(.rect(cornerRadius: 10))
					
					Spacer()
				}
			} else {
				ProgressView()
					.tint(.white)
			}
		}.onAppear {
			authCoordinator.loadProfileUser { profile in
				self.profile = profile
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
