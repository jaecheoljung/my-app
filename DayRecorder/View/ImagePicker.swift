//
//  ImagePicker.swift
//  DayRecorder
//
//  Created by USER on 2022/01/16.
//

import Foundation
import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var image: UIImage?
    
    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(isPresented: _isPresented, image: _image)
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isPresented: Bool
        @Binding var image: UIImage?
        
        init(isPresented: Binding<Bool>, image: Binding<UIImage?>) {
            _isPresented = isPresented
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            image = (info[.originalImage] as? UIImage)?.resize(width: UIScreen.width)
            isPresented.toggle()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isPresented.toggle()
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
