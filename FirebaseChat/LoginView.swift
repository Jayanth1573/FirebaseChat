//
//  LoginView.swift
//  FirebaseChat
//
//  Created by Jayanth Ambaldhage on 29/07/23.
//

import SwiftUI
import Firebase

class FirebaseManager: NSObject{
    let auth: Auth
    
    static let shared = FirebaseManager()
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        super.init()
    }
    
}

struct LoginView: View {

    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
//    init() {
//        FirebaseApp.configure()
//    }
    
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func handleAction(){
        if isLoginMode {
            LoginUser()
        } else {
            CreateNewAccount()
        }
    }
    
    private func LoginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error {
                print("Error sigining in user: \(error)")
            }
            print("Succesfully logged in: \(result?.user.uid ?? "")")
        }
    }
    
    private func CreateNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let error {
                print("Failed to create new user: \(error)")
                return
            }
            print("Succesfully created user: \(result?.user.uid ?? "")")
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
