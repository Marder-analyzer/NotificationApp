//
//  CreateNotificationViewModel.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import Foundation
import Combine
import _PhotosUI_SwiftUI
import FirebaseAuth
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
    @Published var address: String = "Konum seçiliyor..."
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.90, longitude: 41.27),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    // MARK: - Doğrulama (Validation)
    var isValid: Bool {
        return !title.isEmpty && !description.isEmpty
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
        
        if title.trimmingCharacters(in: .whitespacesAndNewlines).count < 3 {
            self.alertMessage = "Lütfen geçerli bir başlık giriniz. (En az 3 karakter)"
            self.showAlert = true
            return
        }
        
        if description.trimmingCharacters(in: .whitespacesAndNewlines).count < 5 {
            self.alertMessage = "Lütfen olayı detaylı açıklayınız. (En az 5 karakter)"
            self.showAlert = true
            return
        }
        
        isSubmitting = true
        
        let currentCoordinate = "\(region.center.latitude), \(region.center.longitude)"
        
        if let image = selectedImage {
            uploadImage(image) { [weak self] imageUrl in
                guard let self = self else { return }
                
                self.createAndSaveNotification(coordinate: currentCoordinate, imageUrl: imageUrl, completion: completion)
            }
        } else {
            createAndSaveNotification(coordinate: currentCoordinate, imageUrl: nil, completion: completion)
        }
    }
    
    private func createAndSaveNotification(coordinate: String, imageUrl: String?, completion: @escaping () -> Void) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM yyyy HH:mm"
        
        let dateString = formatter.string(from: Date())
        let images = imageUrl != nil ? [imageUrl!] : []
        
        let newNotification = NotificationItem(
            type: selectedType,
            title: title,
            description: description,
            date: dateString,
            status: .open,
            userName: Auth.auth().currentUser?.email ?? "",
            address: self.address,
            coordinate: coordinate,
            imageUrls: images
        )
        
        NetworkDataSource().save(newNotification) {
            DispatchQueue.main.async {
                self.isSubmitting = false
                self.alertMessage = "Bildirim başarıyla oluşturuldu!"
                self.showAlert = true
                
                self.title = ""
                self.description = ""
                self.selectedImage = nil
                self.selectedItem = nil
                self.address = ""
                
                completion()
            }
        }
    }
    
    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        let network = NetworkDataSource<NotificationItem>()
        
        network.uploadImage(data: imageData) { urlString in
            completion(urlString)
        }
    }
    
    @MainActor
    func getAddressFromLatLon(latitude: Double, longitude: Double) async {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let locale = Locale(identifier: "tr_TR")
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location, preferredLocale: locale)
            
            guard let place = placemarks.first else {
                self.address = "Bilinmeyen konum."
                return
            }
            
            var addressParts: [String] = []
            
            if let mahalle = place.subLocality { addressParts.append("\(mahalle) Mah.") }
            if let cadde = place.thoroughfare { addressParts.append(cadde) }
            if let no = place.subThoroughfare { addressParts.append("No:\(no)") }
            if let ilce = place.locality { addressParts.append(ilce) }
            if let il = place.administrativeArea { addressParts.append(il) }
            
            let fullAddress = addressParts.joined(separator: " ")
            
            if fullAddress.trimmingCharacters(in: .whitespaces).isEmpty {
                self.address = "\(latitude), \(longitude)"
            } else {
                self.address = fullAddress
            }
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            print("Adres Güncellendi: \(self.address)")
            
        } catch {
            print("Adres hatası: \(error.localizedDescription)")
            self.address = "Adres bulunamadı."
        }
    }
}
