//
//  ConversationView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import SwiftUI

struct ConversationView: View, KeyboardReadable {
    @StateObject var profilePicVM: ProfilePictureViewModel
    @StateObject var convoVM: ConvoViewModel
    @StateObject var messagesVM: MessagesViewModel
    @Binding var data: ConvoModel
    var otherUserID: String
    var convoID: String
    var username: String
    @State private var scrollIndex: Int?
    @State private var messages: [MessageModel] = [MessageModel]()
    @State private var isKeyboardVisible: Bool = false
    var body: some View {
        VStack {
            VStack {
                TitleRow(profilePicVM: profilePicVM, username: username)
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .foregroundColor(Color.black)
                
                ScrollView {
                    ScrollViewReader { proxy in
                        
                        LazyVStack {
                            
                            ForEach(messagesVM.messagesArray, id: \.messageID) { message in
                                MessageBubble(message: MessageModel(messageID: message.messageID, text: message.text, received: message.received   , timestamp: message.timestamp))
                                    .id(message.messageID)
                                //                        Text(message.text)
                            }
                        }
                        
                        .onChange(of: messagesVM.messagesArray) { _ in
                            
                            withAnimation(.spring()) {
                                
                                proxy.scrollTo(messagesVM.messagesArray.last?.messageID, anchor: .bottom)
                            }
                        }
                        
                        
                    }
                    
                    //                .frame(height: UIScreen.main.bounds.height / 2)
                    
                }
                
                //                .background(Color.blue)
                .padding(.top, 10)
                .background(.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
            }
            .background(Color(AppColors.purple).opacity(0.3))
            
            MessageField(data: $data, convoVM: convoVM, otherUserID: otherUserID, conversationID: convoID)
                .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                    //                             print("Is keyboard visible? ", newIsKeyboardVisible)
                    isKeyboardVisible = newIsKeyboardVisible
                    
                }
            
        }
        .onAppear {
            self.messagesVM.fetchMessages { _ in
                self.scrollIndex = messagesVM.messagesArray.count - 1
            }
        }
        //        .padding(.bottom, isKeyboardVisible ? 0 : ((UIApplication.shared.windows.first?.safeAreaInsets.bottom)!) * 2 + 5)
        .offset(y: isKeyboardVisible ? 0 : -((UIApplication.shared.windows.first?.safeAreaInsets.bottom)!) * 2 - 5)
        
        
    }
}

//struct ConversationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConversationView()
//    }
//}
