//
//  ConversationView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import SwiftUI

struct ConversationView: View {
    var messageArray = ["hiii how are you", "i've been great how about you", "this messsaging app is so cool"]
    var body: some View {
        VStack {
            VStack {
                TitleRow(username: "derekhsieh")
                    .foregroundColor(Color.black)
                ScrollView {
                    ForEach(messageArray, id: \.self) { text in
                        MessageBubble(message: MessageModel(commentID: "12345", text: text, received: true, timestamp: Date()))
                    }
                }
                .padding(.top, 10)
                .background(.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
            }
            .background(Color(AppColors.purple).opacity(0.3))
            
            MessageField()
        }
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView()
    }
}
