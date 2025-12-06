//
//  TextFieldConfiguration.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//
import SwiftUI

class TextFieldConfiguration {
	let borderRadius: CGFloat?
	let borderColor: Color?
	let borderWidth: CGFloat?
	let backgroundColor: Color?
	let leftIconColor: Color?
	let rightIconColor: Color?
	let titleColor: Color?
	let textColor: Color?
	let placeHolderColor: Color?
	let height: CGFloat?
	let padding: EdgeInsets?
	let keyboardType: UIKeyboardType?
	let isSecure: Bool?
	
	init(borderRadius: CGFloat? = nil,
			 borderColor: Color? = nil,
			 borderWidth: CGFloat? = nil,
			 backgroundColor: Color? = nil,
			 leftIconColor: Color? = nil,
			 rightIconColor: Color? = nil,
			 titleColor: Color? = nil,
			 textColor: Color? = nil,
			 placeHolderColor: Color? = nil,
			 height: CGFloat? = nil,
			 padding: EdgeInsets? = nil,
			 keyboardType: UIKeyboardType? = nil,
			 isSecure: Bool = false
	) {
		self.borderRadius = borderRadius
		self.borderColor = borderColor
		self.borderWidth = borderWidth
		self.backgroundColor = backgroundColor
		self.leftIconColor = leftIconColor
		self.rightIconColor = rightIconColor
		self.titleColor = titleColor
		self.textColor = textColor
		self.placeHolderColor = placeHolderColor
		self.height = height
		self.padding = padding
		self.keyboardType = keyboardType
		self.isSecure = isSecure
	}
}
