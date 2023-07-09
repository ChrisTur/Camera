import SwiftUI
import UIKit
import UniformTypeIdentifiers
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    var didFinishPicking: (UIImage) -> Void
    
    init(didFinishPicking: @escaping (UIImage) -> Void) {
        self.didFinishPicking = didFinishPicking
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            // Handle the case where the device has no camera
            return UIViewControllerType()
        }
        
        let viewController = UIViewControllerType()
        viewController.delegate = context.coordinator
        viewController.sourceType = .camera
        
        // Request camera authorization
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    // Camera access granted
                } else {
                    // Camera access denied
                    // Handle the denied state gracefully
                }
            }
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Not used in this case
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(didFinishPicking: didFinishPicking)
    }
}

extension CameraView {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var didFinishPicking: (UIImage) -> Void
        
        init(didFinishPicking: @escaping (UIImage) -> Void) {
            self.didFinishPicking = didFinishPicking
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let mediaType = info[.mediaType] as? String,
               mediaType == UTType.image.identifier,
               let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                didFinishPicking(image)
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
