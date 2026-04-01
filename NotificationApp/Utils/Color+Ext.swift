//
//  Color+Ext.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import SwiftUI

extension Color {
	public static func hexConverter(hexString: String) -> Color {
		let hex = hexString.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
		var int = UInt64()
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
		case 3: // RGB (12-bit)
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			return .clear
		}
		return Color(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
	}
}
