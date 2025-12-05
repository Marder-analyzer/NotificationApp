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
}
