//
//  MainMessagesView.swift
//  FirebaseChat
//
//  Created by Jayanth Ambaldhage on 31/07/23.
//

import SwiftUI

struct MainMessagesView: View {
    @State var shouldShowLogOutOptions = false
    private var customNavBar: some View {
        HStack (spacing: 16){
            Image(systemName: "person.fill")
                .font(.system(size: 32,weight: .heavy))
            VStack(alignment: .leading,spacing: 4) {
                Text("Username")
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
                }),
                .cancel()
            ])
        }

    }
    var body: some View {
        NavigationView{
            VStack {
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
