//
//  Date+Extensions.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 4.12.2025.
//

import Foundation

extension Date {
    private static let turkishFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        return formatter
    }()
    
    var toTurkishFormat: String {
        return Date.turkishFormatter.string(from: self)
    }
}
