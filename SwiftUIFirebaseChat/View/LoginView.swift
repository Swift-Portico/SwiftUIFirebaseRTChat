//
//  LoginView.swift
//  SwiftUIFirebaseChat
//
//  Created by Pradeep's Macbook on 06/11/21.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16){
                    Picker(selection: $loginViewModel.isLoginMode, label: Text("Choose Picker")) {
                        Text("Login In")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    if(!loginViewModel.isLoginMode){
                        Button(action:{
                            loginViewModel.isFullScreenPresenetd.toggle()
                        }){
                            VStack {
                                if(loginViewModel.profileImage != nil) {
                                    Image(uiImage: loginViewModel.profileImage!)
                                        .displayImage()
                                } else {
                                    Image(systemName: "person.fill")
                                        .displayImage()
                                }
                            }
                        }
                    }
                    Group{
                        TextField("Username", text: $loginViewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $loginViewModel.password)
                    }
                    .padding(12)
                    .background(Color.white)
                    
                    Button(action:{
                        loginViewModel.handleLoginAction()
                    }){
                        HStack{
                            Spacer()
                            Text(loginViewModel.isLoginMode ? "Login In" : "Create Account")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                            Spacer()
                        }
                        .background(Color.blue)
                    }
                    if(loginViewModel.isTaskExecuting){
                        ProgressView()
                    } else {
                        EmptyView()
                    }
                    Text("\(loginViewModel.loginStatusMessage)")
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            }
            .background(Color(.init(white: 0, alpha: 0.05)))
            .navigationTitle(Text(loginViewModel.isLoginMode ? "Login In" : "Create Account"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $loginViewModel.isFullScreenPresenetd, onDismiss: nil) {
            ImagePickerManager(sourceImage: $loginViewModel.profileImage, isPresented: $loginViewModel.isFullScreenPresenetd)
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
