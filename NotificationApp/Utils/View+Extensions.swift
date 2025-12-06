//
//  View+Extensions.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 4.12.2025.
//

import SwiftUI

extension View {
	func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
	
	func textFieldConfiguration(_ configuration: TextFieldConfiguration) -> some View {
		let cornerRadius = configuration.borderRadius ?? 0
		let borderWidth = configuration.borderWidth ?? 0
		let borderColor = configuration.borderColor ?? .clear
		let backgroundColor = configuration.backgroundColor ?? .clear
		
		return self
			.padding(.horizontal)
			.frame(height: configuration.height)
			.background(
				RoundedRectangle(cornerRadius: cornerRadius)
					.fill(backgroundColor)
			)
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(borderColor, lineWidth: borderWidth)
			)
			.clipShape(
				RoundedRectangle(cornerRadius: cornerRadius)
			)
			.padding(configuration.padding ?? EdgeInsets())
			.foregroundStyle(configuration.textColor ?? .white)
			.keyboardType(configuration.keyboardType ?? .default)
			.autocorrectionDisabled()
			.textInputAutocapitalization(.never)
	}
	
}
