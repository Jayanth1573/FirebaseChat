//
//  MainMessagesView.swift
//  FirebaseChat
//
//  Created by Jayanth Ambaldhage on 31/07/23.
//

import SwiftUI
import SDWebImageSwiftUI




// MARK: - MainMessagesViewModel
class  MainMessagesViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    init() {
        
        self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        fetchCurrentUser()
    }
    
     func fetchCurrentUser() {
       
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
//            self.errorMessage = "Could not find firebase uid"
            return}
        
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user:\(error)")
                return
            }
            guard let data = snapshot?.data() else { return }
            
            self.chatUser = .init(data: data)
        }
    }
    @Published var isUserCurrentlyLoggedOut = false
     func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
         try? FirebaseManager.shared.auth.signOut()
    }
}


// MARK: - MainMessagesView
struct MainMessagesView: View {
    
    @State var shouldShowLogOutOptions = false
    
    @ObservedObject private var vm = MainMessagesViewModel()
    

    private var customNavBar: some View {
        HStack (spacing: 16){
            
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50,height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle (cornerRadius: 44)
                    .stroke(Color(.label),lineWidth: 1))
            
            VStack(alignment: .leading,spacing: 4) {
                Text("\(vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? "")")
                    .font(.system(size: 25,weight: .bold))
                HStack {
                    Circle()
                        .foregroundColor(Color.green)
                        .frame(width: 14,height: 14)
                    Text("Online")
                        .font(.system(size: 14))
                    .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 25,weight: .bold))
                    .foregroundColor(Color(.label))
            }

        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"),message: Text("What do you want to do?"),buttons: [
                .destructive(Text("Sign Out"),action: {
                    print("Sign Out succesfully.")
                    vm.handleSignOut()
                }),
                .cancel()
            ])
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut,onDismiss: nil) {
            LoginView(didCompleteLoginProcess: {
                self.vm.isUserCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
            })
        }
    }
    
    
    // MARK: - body
    var body: some View {
        NavigationView{
            VStack {
//                Text("Current user id: \(vm.errorMessage)")
                customNavBar
                 messagesView
            }
            .overlay(
        newMessageButton ,alignment: .bottom
            )
            .navigationBarHidden(true)

        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10,id: \.self){ num in
                VStack{
                    
                    HStack(spacing: 16){
                        Image(systemName: "person.fill")
                            .font(.system(size:32))
                            .padding(8)
                            .overlay(RoundedRectangle (cornerRadius: 44)
                                .stroke(Color(.label),lineWidth: 1))
                        VStack(alignment: .leading) {
                            Text("Username")
                                .font(.system(size: 16,weight: .bold))
                            Text("Message sent by user")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                            
                        }
                        Spacer()
                        Text("1hr")
                            .font(.system(size: 14,weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical,8)
                    
                }
                .padding(.horizontal)
                
            }
            .padding(.bottom,50)
        }

    }
    
    
    // MARK: - newMessageButton
    private var newMessageButton: some View {
        Button {
         
        } label: {
            HStack{
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16,weight: .bold))
                Spacer()
            }
            .foregroundColor(Color.white)
            .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(24)
                .padding(.horizontal)
                .shadow(radius: 15)
        }
    }
}


struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
//            .preferredColorScheme(.dark)
    }
}
