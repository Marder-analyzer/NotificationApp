//
//  AuthConfigurationFile.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//
import SwiftUI

struct AuthConfiguration {
	let loginEmailConfiguration: TextFieldConfiguration = TextFieldConfiguration(borderRadius: 8,
																																							 borderColor: .gray,
																																							 borderWidth: 1,
																																							 backgroundColor: Color.hexConverter(hexString: "#252a32"),
																																							 titleColor: .gray,
																																							 textColor: .white,
																																							 placeHolderColor: .gray,
																																							 height: 50,
																																							 padding: EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10),
																																							 keyboardType: .emailAddress,
																																							 isSecure: false)
	
	let loginPasswordConfiguration: TextFieldConfiguration = TextFieldConfiguration(borderRadius: 8,
																																									borderColor: .gray,
																																									borderWidth: 1,
																																									backgroundColor: Color.hexConverter(hexString: "#252a32"),
																																									titleColor: .gray,
																																									textColor: .white,
																																									placeHolderColor: .gray,
																																									height: 50,
																																									padding: EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10),
																																									keyboardType: .default,
																																									isSecure: true)
	let registerNameConfiguration: TextFieldConfiguration = TextFieldConfiguration(borderRadius: 8,
																																								 borderColor: .gray,
																																								 borderWidth: 1,
																																								 backgroundColor: Color.hexConverter(hexString: "#252a32"),
																																								 titleColor: .gray,
																																								 textColor: .white,
																																								 placeHolderColor: .gray,
																																								 height: 50,
																																								 padding: EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10),
																																								 keyboardType: .default,
																																								 isSecure: false)
}
