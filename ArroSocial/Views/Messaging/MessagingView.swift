//
//  MessaingView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import SwiftUI

struct MessagingView: View {
    @State private var selectedConvo: [MessageModel]? = nil
    @State private var expand: Bool = false
    @StateObject var convoVM: ConvoViewModel = ConvoViewModel()
    
    var body: some View {
        
        //        TopView(expand: $expand)
        NavigationView {
            
            ZStack {
                Color(AppColors.bg)
                
                Chats(convoVM: convoVM, selectedConvo: $selectedConvo, expand: $expand)
            }
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle("")
            .edgesIgnoringSafeArea(.all)
            
            
            
            
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
    @Binding var selectedConvo: [MessageModel]?
    @State private var sortingSearchText: String = ""
    @Binding var expand : Bool
    
    var body : some View{
        
        VStack(spacing: 0){
            
            TopView(convoVM: convoVM, search: $sortingSearchText, expand: self.$expand).zIndex(5)
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            
            CenterView(convoVM: convoVM, search: $sortingSearchText, expand: self.$expand, selectedConvo: $selectedConvo).offset(y: -25)
        }
        //        .background(Color())
    }
}


struct TopView: View {
    @StateObject var convoVM: ConvoViewModel
    @Binding var search: String
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
            MessagingSearchView(convoVM: convoVM)
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
    @Binding var search: String
    @Binding var expand: Bool
    @Binding var selectedConvo: [MessageModel]?
    var body : some View{
        
        List(convoVM.convosArray) { convo in
            
            if convo.isFiltered {
                if convo == convoVM.convosArray.first {
                    cellView(convoVM: convoVM, data: convo, selectedConvo: $selectedConvo, searchText: $search)
                        .onAppear {
                            self.expand = true
                        }
                        .onDisappear {
                            if convoVM.convosArray.count > 7 {
                                self.expand = false
                            }
                        }
                    
                    
                } else {
                    cellView(convoVM: convoVM, data: convo, selectedConvo: $selectedConvo, searchText: $search)
                    
                    
                }
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
    @StateObject var convoVM: ConvoViewModel
    @State var data: ConvoModel
    @Binding var selectedConvo: [MessageModel]?
    @State var username: String = ""
    @State var otherUserID: String = ""
    @State private var isLoading: Bool = false
    @State private var isFiltered: Bool = false
    @Binding var searchText: String
    
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String = ""
    
    var body: some View {
        NavigationLink {
            ConversationView(profilePicVM: ProfilePictureViewModel(userID: otherUserID), messagesVM: MessagesViewModel(convoID: data.convoID), data: $data, otherUserID: otherUserID, convoID: data.convoID, username: username)
                .navigationBarHidden(true)
            
        } label: {
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
                    
                    Text(self.username)
                    
                    Text(data.lastMessage ?? "").font(.caption)
                        .foregroundColor(Color.gray)
                }
                
                Spacer(minLength: 0)
                
                VStack{
                    
                    Text(messageDate())
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
            .onChange(of: searchText) { newValue in
                print(searchText)
                
                if searchText != "" {
                    if username.contains(searchText.lowercased()) || data.convoID.contains(searchText.lowercased()) {
                        self.updateFilteredStatus(filteredStatus: true)
                    } else {
                        self.updateFilteredStatus(filteredStatus: false)
                    }
                    
                } else {
                    self.updateFilteredStatus(filteredStatus: true)
                }
                
            }
        }
        
        
        
        
        
    }
    
    func updateFilteredStatus(filteredStatus: Bool) {
        if let i = convoVM.convosArray.firstIndex(where: { $0.convoID == data.convoID }) {
            convoVM.convosArray[i].isFiltered = filteredStatus
        }
    }
    
    func messageDate() -> String {
        if isSameDay(date1: Date(), date2: data.lastMessageDate ?? Date()) {
            return data.lastMessageDate?.formatted(.dateTime.hour().minute()) ?? ""
        } else {
            return data.lastMessageDate?.formatted(.dateTime.month().day()) ?? ""
        }
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        if diff.day == 0 {
            return true
        } else {
            return false
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

