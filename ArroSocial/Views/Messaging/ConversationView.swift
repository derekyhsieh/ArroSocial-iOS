//
//  ConversationView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import SwiftUI

struct ConversationView: View, KeyboardReadable {
    @StateObject var profilePicVM: ProfilePictureViewModel
    var otherUserID: String
    var convoID: String?
    var messageArray = ["hiii how are you", "i've been great how about you", "this messsaging app is so cool"]
    @State private var isKeyboardVisible: Bool = false
    var body: some View {
        VStack {
            VStack {
                TitleRow(profilePicVM: profilePicVM, username: "derekhsieh")
                    .foregroundColor(Color.black)
                ScrollView {
                    ForEach(messageArray, id: \.self) { text in
                        MessageBubble(message: MessageModel(messageID: "12345", text: text, received: true, timestamp: Date()))
                    }
                }
                .padding(.top, 10)
                .background(.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
            }
            .background(Color(AppColors.purple).opacity(0.3))
            
            MessageField(otherUserID: otherUserID)
                .padding(.bottom, isKeyboardVisible ? 0 : ((UIApplication.shared.windows.first?.safeAreaInsets.bottom)!) * 2 + 5)
                .onReceive(keyboardPublisher) { newIsKeyboardVisible in
//                             print("Is keyboard visible? ", newIsKeyboardVisible)
                             isKeyboardVisible = newIsKeyboardVisible
                         }
                
        }
    }
}

//struct ConversationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConversationView()
//    }
//}
