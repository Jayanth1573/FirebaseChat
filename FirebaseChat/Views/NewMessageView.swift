//
//  NewMessageView.swift
//  FirebaseChat
//
//  Created by Jayanth Ambaldhage on 02/08/23.
//

import SwiftUI
import SDWebImageSwiftUI


class NewMessageViewModel: ObservableObject {
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    init(){
        fetchAllUsers()
    }
    
   private func fetchAllUsers() {
       FirebaseManager.shared.firestore.collection("users").getDocuments { documentSnapshot, error in
           if let error = error {
               self.errorMessage = "Failed to fetch users: \(error)"
               print("Failed to fetch users: \(error)")
               return
           }
           documentSnapshot?.documents.forEach({ snapshot in
               let data = snapshot.data()
               let user = ChatUser(data: data)
               if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                   self.users.append(.init(data: data))
               }
             
           })
           self.errorMessage = "Fetched users succesfully."
       }
    }
}

struct NewMessageView: View {
    
    let didSelectNewUser: (ChatUser) -> ()
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = NewMessageViewModel()
    var body: some View {
        NavigationView {
            ScrollView {

                ForEach(vm.users) { user in
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack (spacing: 16){
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50,height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color(.label),lineWidth: 1))
                            Text(user.email)
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                    }
                 
                    Divider()
                    .padding(.vertical,8)
                }
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
//        NewMessageView()
        MainMessagesView()
    }
}
