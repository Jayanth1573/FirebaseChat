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
    var body: some View {
        
        VStack {
            ScrollView {
                ForEach(0..<10) { num in
                    HStack {
                        Spacer()
                        HStack {
                            Text("fake message")
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
            HStack (spacing: 16){
                Image(systemName: "photo.fill.on.rectangle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(.darkGray))
                TextField("Description", text: $chatMessage)
                Button {
                    
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
        .navigationTitle(chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: .init(data: ["uid": "real user id","email": "fake@gmail.com"]))
        }
    }
}
