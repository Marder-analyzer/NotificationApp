//
//  LoginContainerView.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import SwiftUI
internal import _LocationEssentials

struct LoginContainerView: View {
	//MARK: - Değişkenler
	@StateObject var authCoordinator = AuthCoordinator()
	@State private var navigateToHome = false
	
	let configuration = AuthConfiguration()
	
	@State private var email: String = ""
	@State private var password: String = ""
	
	//MARK: - Main
	var body: some View {
		ZStack {
			Color.hexConverter(hexString: "#13181f")
				.ignoresSafeArea()
			
			VStack(spacing: 10) {
				welcomeIcon()
					.padding()
				
				Text("Hoş geldiniz")
					.font(.title).bold()
					.foregroundStyle(.white)
				
				Text("Devam etmek için giriş yapın.")
					.foregroundStyle(.gray)
				
				TextFieldComp(title: "E-Posta",
											placeholder: "e-postanızı giriniz",
											configuration: configuration.loginEmailConfiguration)
				.onCodeCompletion { email in
					self.email = email
				}
				.padding(.top)
				
				TextFieldComp(title: "Şifre",
											placeholder: "şifrenizi girin",
											configuration: configuration.loginPasswordConfiguration)
				.onCodeCompletion { password in
					self.password = password
				}
				
				VStack {
					Button(action: {
						Task {
							if
								let user = await authCoordinator.login(email: email, password: password),
								user.id != ""
							{
								navigateToHome = true
							}
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
							Text("Giriş Yap")
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
					Text("Hesabınız yok mu?")
						.foregroundStyle(.white)
					
					NavigationLink {
						RegisterContainerView()
					} label: {
						Text("Kayıt ol")
					}
					
				}
				.padding(.top, 20)
				
				HStack(spacing: 10) {
					Text("Şifrenizi mi unuttunuz?")
						.foregroundStyle(.white)
					
					NavigationLink {
						ResetPasswordView()
					} label: {
						Text("Şifremi Unuttum")
					}
					
				}
				.padding(.top, 10)
			}
		}
		.navigationDestination(isPresented: $navigateToHome) {
			MainTabView()
		}
	}
	
	@ViewBuilder
	private func welcomeIcon() -> some View {
		VStack {
			Image(systemName: "checkmark.circle")
				.resizable()
				.frame(width: 30, height: 30)
		}
		.frame(width: 60, height: 60)
		.background(.blue)
		.clipShape(.rect(cornerRadius: 6))
		
	}
	
}
