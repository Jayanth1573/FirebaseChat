//
//  MainMessagesView.swift
//  FirebaseChat
//
//  Created by Jayanth Ambaldhage on 31/07/23.
//

import SwiftUI
import SDWebImageSwiftUI

// MARK: - MainMessagesView
struct MainMessagesView: View {
    
    @State var shouldShowLogOutOptions = false
    
    @State var shouldNavigateToChatLogView = false
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        NavigationStack{
            
            VStack {
                customNavBar
                messagesView
                
//                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
//                    ChatLogView(chatUser: self.chatUser)
//                } // deprecated after ios 16
                
                .navigationDestination(isPresented: $shouldNavigateToChatLogView) {
                    ChatLogView(chatUser: self.chatUser)
                }
                
            }
            .overlay(
        newMessageButton ,alignment: .bottom
            )
            .navigationBarHidden(true)

        }
    }

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
        
    private var messagesView: some View {
        ScrollView {
            ForEach(vm.recentMessages){ recentMessage in
                VStack{
                    NavigationLink {
                        Text("Destination")
                    } label: {
                        
                        HStack(spacing: 16){
                            WebImage(url: URL(string: recentMessage.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50,height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle (cornerRadius: 50)
                                .stroke(Color(.label),lineWidth: 1))
                                .shadow(radius: 5)
                            
                            VStack(alignment: .leading,spacing: 8) {
                                Text(recentMessage.email)
                                    .font(.system(size: 16,weight: .bold))
                                    .foregroundColor(Color(.label))
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.darkGray))
                                    .multilineTextAlignment(.leading)
                                
                            }
                            Spacer()
                            Text("1hr")
                                .font(.system(size: 14,weight: .semibold))
                        }
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
    
    @State var shouldShowNewMessageScreen = false
    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
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
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
            NewMessageView(didSelectNewUser: {
                user in
                print(user.email)
                self.shouldNavigateToChatLogView.toggle()
                self.chatUser = user
            })
        }
    }
    @State var chatUser: ChatUser?
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
//            .preferredColorScheme(.dark)
    }
}
