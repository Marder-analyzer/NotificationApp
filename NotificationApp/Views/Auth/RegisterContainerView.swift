//
//  RegisterContainerView.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import SwiftUI

struct RegisterContainerView: View {
	@EnvironmentObject var authCoordinator: AuthCoordinator
	@Environment(\.presentationMode) var presentationMode
	
	let configuration = AuthConfiguration()
	
	@State private var name: String = ""
	@State private var email: String = ""
	@State private var password: String = ""
	
	var body: some View {
		ZStack {
			Color.hexConverter(hexString: "#13181f")
				.ignoresSafeArea()
			VStack(spacing: 10) {
				
				TextFieldComp(title: "Ad Soyad",
											placeholder: "Adınız ve Soyadınızı giriniz.",
											configuration: configuration.registerNameConfiguration)
				.onCodeCompletion { name in
					self.name = name
				}
				
				TextFieldComp(title: "E-Posta",
											placeholder: "e-postanızı giriniz.",
											configuration: configuration.loginEmailConfiguration)
				.onCodeCompletion { email in
					self.email = email
				}
				
				TextFieldComp(title: "Şifre",
											placeholder: "şifrenizi giriniz.",
											configuration: configuration.loginPasswordConfiguration)
				.onCodeCompletion { password in
					self.password = password
				}
				
				Spacer()
				
				VStack {
					Button(action: {
						Task {
							await authCoordinator.register(email: email, password: password)
						}
					}) {
						if authCoordinator.isLoading {
							VStack {
								ProgressView()
									.tint(.white)
							}
							.frame(maxWidth: .infinity, minHeight: 50)
							.background(Color.hexConverter(hexString: "#3a71e4"))
							.foregroundColor(.white)
							.cornerRadius(5)
						} else {
							Text("Register")
								.frame(maxWidth: .infinity, minHeight: 50)
								.background(Color.hexConverter(hexString: "#3a71e4"))
								.foregroundColor(.white)
								.cornerRadius(5)
						}
						
					}
				}
				.padding(.horizontal, 10)
				.padding(.top, 30)
				
				HStack(spacing: 10) {
					Text("Zaten bir hesabınız bulunuyor mu?")
						.foregroundStyle(.white)
					Button {
						self.presentationMode.wrappedValue.dismiss()
					} label: {
						Text("Giriş Yap")
					}
				}
				.padding(.top, 20)
			}
			.padding(.vertical)
		}
		.toolbar(content: {
			ToolbarItem(placement: .principal) {
				Text("Kayıt ol")
					.foregroundStyle(.white)
			}
		})
//		.navigationTitle("Kayıt Ol")
	}
	
}

#Preview {
	let repo = FirebaseAuthRepository()
	let coordinator = AuthCoordinator(repository: repo)
	
	return RegisterContainerView()
		.environmentObject(coordinator)
}
