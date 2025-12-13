//
//  LocationConfigurationFile.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 10.12.2025.
//

import SwiftUI

struct LocationConfiguration {
    let createNotificationTitleConfiguration: TextFieldConfiguration = TextFieldConfiguration(borderRadius: 10,
                                                                                              borderColor: .white.opacity(0.2),
                                                                                              borderWidth: 1,
                                                                                              backgroundColor: Color.hexConverter(hexString:"#1c2630"),
                                                                                              titleColor: Color.hexConverter(hexString: "#8e8e93"),
                                                                                              textColor: .white,
                                                                                              placeHolderColor: Color.hexConverter(hexString: "#8e8e93"),
                                                                                              height: 50,
                                                                                              isSecure: false,
                                                                                              accentColor: Color.white)
    
    
    let chooseLocationConfiguration: TextFieldConfiguration = TextFieldConfiguration(textColor: .white,
                                                                                     placeHolderColor: Color.hexConverter(hexString: "#8e8e93"),
                                                                                     accentColor: Color.white)
    
    let descriptionConfiguration = TextFieldConfiguration(
        borderRadius: 10,
         borderColor: .white.opacity(0.2),
         borderWidth: 1,
         backgroundColor: Color.hexConverter(hexString:"#1c2630"),
         textColor: .white,
         placeHolderColor: Color.hexConverter(hexString: "#8e8e93"),
         isSecure: false 
    )
}
