//
//  GoogleButton.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-06-25.
//

import SwiftUI

struct GoogleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack{
                
                Rectangle()
                    .cornerRadius(15)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    .frame(width: 200, height: 30)
                    .overlay(alignment: .center) {
                        Text("Sign in with Google")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.black)
                            .offset(x:8)
                    }
                
                Image("google")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .clipShape(Circle())
                    .frame(width: 150, height: 40)
                    .offset(x:-85)
            }
        }
        
    }
}

struct GoogleButton_Previews:PreviewProvider {
    static var previews: some View {
        GoogleButton(action: {})
    }
}
