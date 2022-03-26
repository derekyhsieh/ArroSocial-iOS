//
//  MessageBubble.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import SwiftUI

struct MessageBubble: View {
    var message: MessageModel
    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: message.received ? .leading: .trailing) {
            HStack {
                Text(message.text)
//                    .modifier(Poppins(fontWeight: AppFont.regular, .caption2))
                    .padding()
                    .background(message.received ? Color(AppColors.messageGray) : Color(AppColors.purple).opacity(0.3))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: message.received ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
//                    .modifier(Poppins(fontWeight: AppFont.regular, .caption2))
                    .foregroundColor(.gray)
                    .padding(message.received ? .leading : .trailing, 25)
            }
        }
        
        .frame(maxWidth: .infinity, alignment: message.received ? .leading : .trailing)
        .padding(message.received ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: MessageModel(messageID: "21234", text: "this is a test messsage does it work?!", received: false, timestamp: Date()))
    }
}
