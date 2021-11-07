//
//  LoginViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Pradeep's Macbook on 07/11/21.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    
    @Published var isLoginMode        = false
    @Published var email              = ""
    @Published var password           = ""
    @Published var loginStatusMessage = ""
    @Published var profileImage: UIImage?
    @Published var isFullScreenPresenetd = false
    @Published var isTaskExecuting = false
    
    func handleLoginAction() {
        if(isLoginMode) {
            isTaskExecuting = true
            FirebaseManager
                .sharedInstance
                .auth.signIn(withEmail: email,
                             password: password) { [weak self] result, error in
                    guard let self = self else {
                        self?.isTaskExecuting = false
                        return
                    }
                    if let err = error {
                        self.loginStatusMessage = "Failed to login user with error: \(err.localizedDescription)"
                        self.isTaskExecuting = false
                        return
                    }
                    
                    self.loginStatusMessage = "Succesfully Logged In with user id: \(result?.user.uid ?? "")"
                    self.isTaskExecuting = false
                }
        } else {
            isTaskExecuting = true
            FirebaseManager
                .sharedInstance
                .auth
                .createUser(withEmail: email,
                            password: password) { [weak self] result, error in
                    guard let self = self else {
                        self?.isTaskExecuting = false
                        return
                    }
                    if let err = error {
                        self.loginStatusMessage = "Failed to create user with error: \(err.localizedDescription)"
                        self.isTaskExecuting = false
                        return
                    }
                    
                    self.loginStatusMessage = "Succesfully created the user with user id: \(result?.user.uid ?? "")"
                    
                    self.persistImageToStorage()
                }
        }
    }
    
    func persistImageToStorage() {
        guard let uniqueId = FirebaseManager.sharedInstance.auth.currentUser?.uid else {
            self.isTaskExecuting = false
            return
        }
        let ref = FirebaseManager
            .sharedInstance
            .storage
            .reference(withPath: uniqueId)
        guard let profileImageData = profileImage?.jpegData(compressionQuality: 0.1) else {
            self.isTaskExecuting = false
            return
        }
        ref.putData(profileImageData, metadata: nil) { [weak self] metaData, error in
            guard let self = self else {
                self?.isTaskExecuting = false
                return
            }
            if let err = error {
                self.loginStatusMessage = "Failed to upload image to the storage with error: \(err.localizedDescription)"
                self.isTaskExecuting = false
                return
            }
            ref.downloadURL { [weak self] url, error in
                guard let self = self else {
                    self?.isTaskExecuting = false
                    return
                }
                if let err = error {
                    self.loginStatusMessage = "Failed to retreive the download url: \(err.localizedDescription)"
                    self.isTaskExecuting = false
                    return
                }
                self.loginStatusMessage = "Successfully downloaded the image with url: \(url?.absoluteString ?? "")"
                guard let url = url else { return }
                self.storeUserInformation(profileImageUrl: url)
            }
        }
    }
    
    func storeUserInformation(profileImageUrl: URL) {
        guard let uid = FirebaseManager.sharedInstance.auth.currentUser?.uid else{
            self.isTaskExecuting = false
            return
        }
        let documentData = ["email": email, "uid": uid, "profileImageURL": profileImageUrl.absoluteString]
        FirebaseManager.sharedInstance.fireStore.collection("users")
            .document(uid).setData(documentData) {[weak self] err in
                guard let self = self else {
                    self?.isTaskExecuting = false
                    return
                }
                if let err = err {
                    self.loginStatusMessage = "\(err.localizedDescription)"
                    self.isTaskExecuting = false
                    return
                }
                print("*** Succesfully Stored User Data in the FireStore ***")
                self.loginStatusMessage = "Succesfully Stored User Data in the FireStore"
                self.isTaskExecuting = false
            }
    }
    
    deinit {
        print("*** OS Reclaiming Its Memory ***")
    }
    
}
