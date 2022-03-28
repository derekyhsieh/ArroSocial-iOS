//
//  MessaingView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import SwiftUI

struct MessagingView: View {
    @State private var expand: Bool = false
    @StateObject var convoVM: ConvoViewModel = ConvoViewModel()
    
    var body: some View {
        
        //        TopView(expand: $expand)
        ZStack {
            Color(AppColors.bg)
            
            Chats(convoVM: convoVM, expand: $expand)
        }
    }
}

struct MessaingView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingView()
    }
}
struct Chats : View {
    @StateObject var convoVM: ConvoViewModel
    
    @Binding var expand : Bool
    
    var body : some View{
        
        VStack(spacing: 0){
            
            TopView(convoVM: convoVM, expand: self.$expand).zIndex(5)
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            
            CenterView(convoVM: convoVM, expand: self.$expand).offset(y: -25)
        }
        //        .background(Color())
    }
}


struct TopView: View {
    @StateObject var convoVM: ConvoViewModel
    @State var search = ""
    @Binding var expand: Bool
    @State private var showAddSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 22) {
            if self.expand {
                HStack {
                    Text("Messages")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(Color.black.opacity(0.7))
                    Spacer()
                    
                    Button(action: {
                        self.showAddSheet.toggle()
                    }) {
                        
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(AppColors.purple))
                            .padding(18)
                        
                    }
                    
                }
                
                
            }
            
            SearchBar(search: $search)
        }
        .padding()
        .background(Color(AppColors.bg))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .animation(.default)
        .sheet(isPresented: $showAddSheet) {
            SearchView(convoVM: convoVM)
        }
    }
}

struct SearchBar: View {
    @Binding var search: String
    var placeholder: String = "Search"
    
    var body: some View {
        HStack(spacing: 15){
            
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(Color.black.opacity(0.3))
            
            TextField(placeholder, text: self.$search)
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .padding(.bottom, 10)
    }
    
}


struct CenterView: View {
    @StateObject var convoVM: ConvoViewModel
    @Binding var expand: Bool
    var body : some View{
        
        List(convoVM.convosArray) { convo in
            
            if convo == convoVM.convosArray.first {
                
                cellView(data: convo)
                    .onAppear {
                        self.expand = true
                    }
                    .onDisappear {
                        if convoVM.convosArray.count > 7 {
                            self.expand = false
                        }
                    }
            } else {
                
                cellView(data: convo)
            }
            
        }
        .background(Color(AppColors.bg))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            self.expand = true
        }
    }
}

struct cellView : View {
    
    var data: ConvoModel
    @State var username: String = ""
    @State var otherUserID: String = ""
    @State private var isLoading: Bool = false
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String = ""
    
    var body: some View {
        
        HStack(spacing: 12) {
            
            if !isLoading {
                ProfilePicture(dimension: 50, username: username, userID: getOtherParticipantID(), profilePicVM: ProfilePictureViewModel(userID: otherUserID))
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
                    .redacted(reason: isLoading ? .placeholder : [])
            }
            
            
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text(self.username )
                
                Text(data.lastMessage ?? "").font(.caption)
            }
            
            Spacer(minLength: 0)
            
            VStack{
                
                Text(data.lastMessageDate?.formatted(.dateTime.month().day()) ?? "")
                    .foregroundColor(Color.gray)
                
                Spacer()
            }
        }
        .padding(.vertical)
        .onAppear {
            self.isLoading = true
            
            self.otherUserID = getOtherParticipantID()
            DataService.instance.getUserDocument(userID: otherUserID) { doc in
                if let doc = doc {
                    self.username = doc.get(FSUserData.username) as! String
                    
                    self.isLoading = false
                }
                
            }
        }
        
    }
    
    func getOtherParticipantID() -> String {
        
        for participant in self.data.participantsID {
            if participant != currentUserID {
                
                return participant
            }
        }
        return ""
        
        
    }
}


struct Msg : Identifiable {
    
    var id : Int
    var name : String
    var msg : String
    var date : Date
    var img : String
    
}

