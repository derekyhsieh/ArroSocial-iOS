//
//  MessageField.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import SwiftUI

struct MessageField: View {
    @State private var message = ""
    @State private var isUploading: Bool = false
    var otherUserID: String
    var conversationID: String?
    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("enter your message here"), text: $message)
            
            Button(action: {
               uploadComment()
            }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(Color.white)
                    .padding(10)
                    .background(Color(AppColors.purple))
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(AppColors.messageGray))
        .cornerRadius(50)
        .padding()
        .disabled(isUploading)
    }
    
    func uploadComment() {
        
        
        if message.isEmpty {
          // don't do anything since empty
        } else {
           // not empty
            isUploading = true
            
            DataService.instance.uploadMessage(conversationID: nil, otherUserID: otherUserID, messageText: message) { messageID, conversationID in
                print("successful")
                isUploading = false
            }
        }
    }
}

//struct MessageField_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageField()
//    }
//}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder.opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
