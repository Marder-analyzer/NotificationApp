//
//  RegisterContainerView.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import SwiftUI

struct RegisterContainerView: View {
	@StateObject var authCoordinator = AuthCoordinator()
	@Environment(\.presentationMode) var presentationMode
    @State private var selectedNotificationType: NotificationType = .security

	let configuration = AuthConfiguration()
	
	@State private var name: String = ""
	@State private var email: String = ""
	@State private var password: String = ""
	@State private var selectedIndex = 1
	@State private var isPresented: Bool = false
	@State private var errorMessage: String? = ""
	
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
				
				VStack(alignment: .leading) {
					Text("Bildirim Türü")
						.foregroundStyle(.white)
					
					NotificationTypeSelectionView(
						selectedType: $selectedNotificationType
					)
				}
				.padding(.horizontal, 10)
				
				VStack {
					Text("Kullanıcı Rolünüzü Seçiniz")
						.foregroundStyle(.white)
					HStack {
						Button {
							selectedIndex = 1
						} label: {
							Text("Admin")
								.foregroundStyle(.white)
						}
						.frame(width: UIScreen.main.bounds.width / 3, height: 50)
						.background(selectedIndex == 1 ? .blue : .gray)
						.clipShape(RoundedRectangle(cornerRadius: 12))
						Button {
							self.selectedIndex = 0
						} label: {
							Text("Kullanıcı")
								.foregroundStyle(.white)
						}
						.frame(width: UIScreen.main.bounds.width / 3, height: 50)
						.background(selectedIndex == 1 ? .gray : .blue)
						.clipShape(RoundedRectangle(cornerRadius: 12))
					}
				}
                
				Spacer()
				
				VStack {
					Button(action: {
						Task {
							let result = await authCoordinator.register(email: email, password: password, nameSurname: name, userType: selectedIndex == 1 ? "admin" : "user", department: selectedNotificationType.rawValue)
							if let result {
								self.errorMessage = "Kayıt olma başarılı login olabilirsiniz"
								isPresented.toggle()
							} else {
								self.errorMessage = authCoordinator.errorMessage
								isPresented.toggle()
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
							Text("Kayıt ol")
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
		.alert(self.errorMessage ?? "", isPresented: $isPresented, actions: {
			Button {
				self.presentationMode.wrappedValue.dismiss()
			} label: {
				Text("OK")
			}.frame(width: 100, height: 50)
				.background(.blue)
				.clipShape(RoundedRectangle(cornerRadius: 10))

		}, message: {
			
		})
//		.navigationTitle("Kayıt Ol")
	}
	
}
