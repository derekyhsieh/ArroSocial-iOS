//
//  SearchView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/26/22.
//

import SwiftUI

struct SearchView: View {
    @State private var searchQuery: String = ""
    @StateObject var usersVM: UsersViewModel = UsersViewModel(userQuery: "")
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String = ""
    @State private var isFetching: Bool = false
    @StateObject var convoVM: ConvoViewModel
    
    var body: some View {
        ZStack {
            Color(AppColors.bg)
            VStack(spacing: 0) {
                HStack {
                    Text("Start a convo")
                        .modifier(Poppins(fontWeight: AppFont.medium, .title3))
                    Spacer()
                }
                .padding()
                SearchBar(search: $searchQuery, placeholder: "Search for username")
                    .padding()
                    .onChange(of: searchQuery) { newValue in
                        print("updating")
                        usersVM.updateUsersFromQuery(userQuery: newValue)
                    }
                
                
                
                if usersVM.usersArray.count == 0 || searchQuery == "" {
                    // no users
                    
                    Text("no users found")
                        .modifier(Poppins(fontWeight: AppFont.regular, .subheadline))
                        .foregroundColor(Color.gray)
                    
                } else {
                    List(usersVM.usersArray) { user in
                        if user.userID != currentUserID {
                            
                            UserCellView(isFetching: $isFetching, isAlreadyChatting: convoVM.alreadyChattingUserIDs.contains(user.userID), convoVM: convoVM, data: user)
                        }
                    }
                    
                    
                }
                Spacer(minLength: 0)
                
            }
            CustomLoadingIndicator(isShowing: $isFetching)
        }
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}

struct UserCellView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isFetching: Bool
    var isAlreadyChatting: Bool
    @StateObject var convoVM: ConvoViewModel
    
    var data: UsersModel
    var body: some View {
        HStack(spacing: 12) {
            ProfilePicture(dimension: 55, username: data.username, userID: data.userID, profilePicVM: ProfilePictureViewModel(userID: data.userID))
            
            Text(data.username)
            Spacer(minLength: 0)
            Button {
                
                // create new convo
                
                if isAlreadyChatting {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    isFetching = true
                    convoVM.uploadNewConvo(userID: data.userID) { success in
                        presentationMode.wrappedValue.dismiss()
                        isFetching = false
                    }
                }
                
                
                
                
            } label: {
                Image(systemName: isAlreadyChatting ? "checkmark" : "plus")
                    .foregroundColor(isAlreadyChatting ? .green : .blue)
            }
            
        }
    }
}
