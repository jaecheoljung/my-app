//
//  ImagePicker.swift
//  DayRecorder
//
//  Created by USER on 2022/01/16.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    enum Source {
        case camera
        case photoLibrary
    }
    
    @Binding var isPresented: Bool
    @Binding var image: UIImage?
    var sourceType: Source
    
    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(isPresented: _isPresented, image: _image)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIViewController {
        if sourceType == .camera {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = context.coordinator
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
            }
            
            return imagePicker
        }
        
        if sourceType == .photoLibrary {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = context.coordinator
            return picker
        }
        
        return UIViewController()
    }
    
    class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate {
        @Binding var isPresented: Bool
        @Binding var image: UIImage?
        
        init(isPresented: Binding<Bool>, image: Binding<UIImage?>) {
            _isPresented = isPresented
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            image = (info[.originalImage] as? UIImage)?.resize(width: UIScreen.width * 1.5)
            isPresented.toggle()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isPresented.toggle()
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
                isPresented.toggle()
                return
            }
            
            provider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.image = image as? UIImage
                    self.isPresented.toggle()
                }
            }
        }
    }
}


extension UIScreen {
    static var width: CGFloat {
        screens.first?.bounds.width ?? 520
    }
}

extension UIImage {
    func resize(width: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: size.height * (width / size.width))
        
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
