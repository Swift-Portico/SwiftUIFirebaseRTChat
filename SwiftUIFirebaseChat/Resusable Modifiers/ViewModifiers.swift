//
//  ViewModifiers.swift
//  SwiftUIFirebaseChat
//
//  Created by Pradeep's Macbook on 07/11/21.
//

import SwiftUI

extension Image {
    func displayImage() -> some View {
        self
            .resizable()
            .frame(width: 128, height: 128)
            .foregroundColor(Color.black)
            .cornerRadius(64)
            .overlay(
                RoundedRectangle.init(cornerRadius: 64)
                    .stroke(Color.black, lineWidth: 3)
            )
        
    }
}
