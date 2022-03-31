//
//  ExploreView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/30/22.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchQuery: String = ""
    @StateObject var usersVM: UsersViewModel = UsersViewModel(userQuery: "")
    @State private var showProfile: Bool = false
    @Binding var selectedPost: FullScreenPostModel?
    @State private var selectedUserID: String?
    @State private var expand: Bool = false
    @State var offset: CGFloat = 0
    @State var startOffset: CGFloat = 0
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String = ""
    var body: some View {
        VStack {
            
            if expand {
                
                HStack {
                    (
                        Text("My")
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        +
                        
                        Text("exploration")
                            .foregroundColor(Color.gray)
                        
                        
                    )
                    .font(.largeTitle)
                    
                    Spacer()
                }
                .padding()
            }
            
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.gray)
                
                TextField("Search", text: $searchQuery)
                
            }
            .onChange(of: searchQuery, perform: { newValue in
                usersVM.updateUsersFromQuery(userQuery: newValue)
            })
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.primary.opacity(0.05))
            .cornerRadius(8)
            .padding(.horizontal)
            
            
            List(usersVM.usersArray) { user in
                
                // make sure user doesnt find themself
                if user.userID != currentUserID {
                    if user.userID == usersVM.usersArray.first?.userID {
                        
                        ExploreUser(userID: user.userID, selectedPost: $selectedPost, showProfile: $showProfile)
                            .onAppear {
                                withAnimation() {
                                    self.expand = true
                                }
                            }
                            .onDisappear {
                                withAnimation() {
                                    
                                    self.expand = false
                                }
                            }
                    } else {
                        ExploreUser(userID: user.userID, selectedPost: $selectedPost, showProfile: $showProfile)
                    }
                }
                
           
                
                
            }
            .padding(.top, 10)
            
            
        }
        
        .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)!)
        
        .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)!)
    }
}

//struct ExploreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreView()
//    }
//}
