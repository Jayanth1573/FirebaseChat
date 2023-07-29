//
//  LoginView.swift
//  FirebaseChat
//
//  Created by Jayanth Ambaldhage on 29/07/23.
//

import SwiftUI

struct LoginView: View {
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing: 18){
                    Picker(selection: $isLoginMode) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    } label: {
                        Text("Picker here")
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 65))
                                .padding()
                        }
                    }
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(12)
                        .background(Color.white)
                    SecureField("Password", text: $password)
                        .padding(12)
                        .background(Color.white)
                    Button {
                        handleAction()
                        
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Login" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical,12)
                                .font(.system(size: 16,weight: .semibold))
                            Spacer()
                        }
                        .background(Color.blue)
                    }
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Login": "Create Account")
            .background(Color(white: 0, opacity: 0.05))
        }
    }
    
    private func handleAction(){
        if isLoginMode {
            print("Login using existing credentials")
        } else {
            print("Create a new account.")
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
