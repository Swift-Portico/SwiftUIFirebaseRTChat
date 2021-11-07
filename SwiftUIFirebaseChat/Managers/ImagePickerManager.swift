//
//  ImagePickerManager.swift
//  SwiftUIFirebaseChat
//
//  Created by Pradeep's Macbook on 07/11/21.
//

import UIKit
import SwiftUI

struct ImagePickerManager: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    
    @Binding var sourceImage: UIImage?
    
    @Binding var isPresented: Bool
    
    var imagePickerViewController = UIImagePickerController()
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        imagePickerViewController.delegate = context.coordinator
        return imagePickerViewController
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator.init(self)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var parent: ImagePickerManager
    init(_ parent: ImagePickerManager) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.parent.sourceImage = info[.originalImage] as? UIImage
        self.parent.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.parent.isPresented = false
    }
}
