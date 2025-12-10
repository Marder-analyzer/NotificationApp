//
//  TextFieldComp.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation
import SwiftUI

struct TextFieldComp: View {
	
	@State var title: String?
	@State var placeholder: String?
    var externalText: Binding<String>?
    
    @State private var internalText: String = ""
    
	@State private var debounceTask: Task<Void, Never>?
	private var onCodeCompletion: ((String) -> Void)?
	
	let configuration: TextFieldConfiguration
	
    private var textBinding: Binding<String> {
        return externalText ?? $internalText
    }
    
	init(title: String?,
			 placeholder: String? = nil,
         text: Binding<String>? = nil,
			 configuration: TextFieldConfiguration) {
		self.title = title
		self.placeholder = placeholder
        self.externalText = text
		self.configuration = configuration
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			if let title {
				Text(title)
					.foregroundStyle(configuration.titleColor ?? .black)
					.padding(configuration.padding ?? EdgeInsets())
			}
			
			if configuration.isSecure ?? false {
				SecureField("", text: textBinding, prompt: Text(placeholder ?? "").foregroundStyle(configuration.placeHolderColor ?? Color.gray))
					.textFieldConfiguration(configuration)
			} else {
				TextField("", text: textBinding, prompt: Text(placeholder ?? "").foregroundStyle(configuration.placeHolderColor ?? Color.gray))
					.textFieldConfiguration(configuration)
			}
		}
		.onChange(of: textBinding.wrappedValue, { oldValue, newValue in
			debounceTask?.cancel()
			
			debounceTask = Task {
				try? await Task.sleep(nanoseconds: 300_000_000)
				onCodeCompletion?(newValue)
			}
		})
	}
	
	public func onCodeCompletion( _ closure: @escaping (String) -> Void) -> Self {
		var copy = self
		copy.onCodeCompletion = closure
		return copy
	}
}
