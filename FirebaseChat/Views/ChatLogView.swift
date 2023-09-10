//
//  ChatLogView.swift
//  FirebaseChat
//
//  Created by Jayanth Ambaldhage on 04/08/23.
//

import SwiftUI

struct ChatLogView: View {
    @State var chatMessage = ""
    
    let chatUser: ChatUser?
    init(chatUser: ChatUser) {
        self.chatUser = chatUser
        self.vm = .init(chatUser: chatUser)
    }
    @ObservedObject var vm: ChatLogViewModel
    
    
    var body: some View {
        ZStack {
            messageView
            Text(vm.errorMessage)
        }
        
        
        .navigationTitle(chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var messageView: some View {
        ScrollView {
            ForEach(0..<10) { num in
                HStack {
                    Spacer()
                    HStack {
                        Text("NOT SO fake message")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top,8)
            }
            HStack{
                Spacer()
            }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
        .safeAreaInset(edge: .bottom) {
            chatBottomBar
                .background(Color(.systemBackground)
                    .ignoresSafeArea())
        }
    }
    private var chatBottomBar: some View {
        HStack (spacing: 16){
            Image(systemName: "photo.fill.on.rectangle.fill")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            TextField("Description", text: $vm.chatMessage)
            Button {
                vm.handleSend()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical,8)
            .background(Color.blue)
            .cornerRadius(5)
            
        }
        .padding(.horizontal)
        .padding(.vertical,8)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: .init(data: ["uid": "real user id","email": "fake@gmail.com"]))
        }
    }
}
