//
//  RootView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 25.12.2025.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
	@EnvironmentObject var appState: AppState

	var body: some View {
		ZStack(alignment: .top) {
			
			NavigationStack {
				if let user = Auth.auth().currentUser {
					MainTabView()
						.navigationBarHidden(true)
				} else {
					LoginContainerView()
						.navigationBarHidden(true)
				}
			}
			
			if let popup = appState.activePopup {
				PopupView(
					title: popup.title,
					description: popup.description,
					onClose: { appState.dismissPopup() }
				)
				.padding(.top, 14)
				.padding(.horizontal, 14)
				.transition(.move(edge: .top).combined(with: .opacity))
				.zIndex(999)
				.onAppear {
					// otomatik kapanma (opsiyonel)
					DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
						// hâlâ aynı popup ise kapat
						if appState.activePopup?.id == popup.id {
							appState.dismissPopup()
						}
					}
				}
			}
		}
		.animation(.default, value: appState.activePopup)
	}
}

private struct MainContent: View {
	var body: some View { Text("Home") }
}

private struct PopupView: View {
	let title: String
	let description: String
	let onClose: () -> Void

	var body: some View {
		VStack(alignment: .leading, spacing: 6) {
			HStack {
				Text(title).font(.headline)
				Spacer()
				Button(action: onClose) { Image(systemName: "xmark") }
			}
			Text(description).font(.subheadline).foregroundStyle(.secondary)
		}
		.padding(14)
		.background(.ultraThinMaterial)
		.clipShape(RoundedRectangle(cornerRadius: 16))
		.shadow(radius: 10)
	}
}

#Preview {
    RootView()
}

