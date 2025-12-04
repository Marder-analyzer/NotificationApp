//
//  CreateNotificationViewModel.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import Foundation
import Combine
import _PhotosUI_SwiftUI
internal import MapKit

class CreateNotificationViewModel: ObservableObject {
    
    // MARK: - Değişkenler
    @Published var selectedType: NotificationType = .security
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var useCurrentLocation: Bool = true
    
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedImage: UIImage? = nil
    
    @Published var isSubmitting: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showCamera: Bool = false
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.90, longitude: 41.27), 
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    // MARK: - Doğrulama (Validation)
    var isValid: Bool {
        return title.count >= 3 && description.count >= 5
    }
    
    // MARK: - Fonksiyonlar
    @MainActor
    func convertPhoto() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.selectedImage = uiImage
    }
    
    func submitNotification(completion: @escaping () -> Void) {
        isSubmitting = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isSubmitting = false
            self.alertMessage = "Bildirim başarıyla oluşturuldu!"
            self.showAlert = true
            completion()
        }
    }
}
