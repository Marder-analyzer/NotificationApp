//
//  ResetPasswordView.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 24.12.2025.
//


import SwiftUI
internal import _LocationEssentials

struct ResetPasswordView: View {
	//MARK: - Değişkenler
	@StateObject var authCoordinator = AuthCoordinator()
	@State private var navigateToHome = false
	
	let configuration = AuthConfiguration()
	
	@State private var email: String = ""
	@State private var password: String = ""
	
	@State private var showAlert = false
	@State private var alertTitle = ""
	
	//MARK: - Main
	var body: some View {
		NavigationStack {
			ZStack {
				Color.hexConverter(hexString: "#13181f")
					.ignoresSafeArea()
				
				VStack(spacing: 10) {
					Text("Şifrenizi Değiştirin")
						.font(.title).bold()
						.foregroundStyle(.white)
					
					TextFieldComp(title: "E-Posta",
												placeholder: "e-postanızı giriniz",
												configuration: configuration.loginEmailConfiguration)
					.onCodeCompletion { email in
						self.email = email
					}
					.padding(.top)
					
					VStack {
						Button(action: {
							Task {
								authCoordinator.resetPassword(email: email) { error in
									if let error {
										self.alertTitle = error
										showAlert = true
									} else {
										self.alertTitle = "Şifre yenileme isteği gönderildi lütfen mailinizi kontrol edin."
										showAlert = true
									}
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
								Text("Şifreyi Yenile")
									.frame(maxWidth: .infinity, minHeight: 50)
									.background(Color.hexConverter(hexString: "#3a71e4"))
									.foregroundColor(.white)
									.cornerRadius(5)
							}
						}
					}
					.padding(.horizontal, 10)
					.padding(.top, 30)
					
				}
			}
		}
		.alert(alertTitle, isPresented: $showAlert) {
				Button("Tamam", role: .cancel) {}
		} message: {
		}
		
	}
	
}
