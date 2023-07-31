//
//  LoginView.swift
//  FirebaseChat
//
//  Created by Jayanth Ambaldhage on 29/07/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

class FirebaseManager: NSObject{
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    static let shared = FirebaseManager()
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
    
}

struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
 
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
                            shouldShowImagePicker.toggle()
                        } label: {
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120,height: 120)
                                      
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 65))
                                        .foregroundColor(Color.black)
                                        .padding()
                                    
                                }
                            }
                            .clipShape(Circle())
                            .overlay{
                                Circle().stroke(.black, lineWidth: 3)
                            }
                            
                            
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
        .fullScreenCover(isPresented: $shouldShowImagePicker,onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
    
    private func handleAction(){
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error {
                print("Error sigining in user: \(error)")
            }
            print("Succesfully logged in: \(result?.user.uid ?? "")")
        }
    }
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let error {
                print("Failed to create new user: \(error)")
                return
            }
            print("Succesfully created user: \(result?.user.uid ?? "")")
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
//        let fileName = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else
        { return }
       let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to push image to storage: \(error)")
                return
            }
            ref.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve downloaded url: \(error)")
                    return
                }
                guard let url = url else {return}
                self.storeUserInformation(imageProfileUrl: url)
                print("Succesfully stored image")
            }
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Error saving data to firestore:\(error)")
                return
            }
            print("Success saving data to firestore")
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
