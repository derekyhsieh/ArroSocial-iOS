//
//  HomeFeedView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/1/22.
//

import SwiftUI
import PermissionsSwiftUI
import Photos

// model for pull down to refresh
struct Refresh {
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    var started: Bool
    var released: Bool
    var invalidScroll: Bool = false
}

struct HomeFeedView: View {
    @AppStorage(CurrentUserDefaults.profilePicColor) var profilePicColorBackground: String = ""
    @AppStorage(CurrentUserDefaults.username) var username: String = ""
    @AppStorage(CurrentUserDefaults.userID) var userID: String = ""
    @AppStorage("gottenUserPermissions") var gottenUserPermissions: Bool = false
    @StateObject var profilePictureVM: ProfilePictureViewModel
    @Binding var isShowingUploadView: Bool
    @Binding var showPermissionsModal: Bool
    @State var refresh = Refresh(started: false, released: false)
    
    @StateObject var posts: PostsViewModel
    
    
    var body: some View {
        ZStack {
            Color(AppColors.bg).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    
                    HStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 42, height: 42)
                            .foregroundColor(.white)
                            .padding(2)
                            .background(Color(AppColors.purple) .clipShape(Circle()))
                            .shadow(color: Color.black.opacity(0.2), radius: 60, x: 0.0, y: 16)
                        
                        
                        
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // check if app storage has gotten
                        //                        if !self.gottenPermissions {
                        self.showPermissionsModal = true
                        
                        if(self.gottenUserPermissions) {
                            
                            self.isShowingUploadView = true
                        }
                        
                        
                        
                        
                        //                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.title.bold())
                            .frame(width: 30, height: 30)
                            .padding(10)
                            .padding(.horizontal, 10)
                            .foregroundColor(Color.black.opacity(0.7))
                            .background(
                                Circle()
                                    .fill(Color.gray.opacity(0.15))
                                    .shadow(color: Color.black.opacity(0.2), radius: 60, x: 0.0, y: 16)
                            )
                    }
                    
                    Spacer()
                    
                    
                    HStack {
                        
                        if profilePictureVM.isFinishedFetchingProfilePicture {
                            if profilePictureVM.profilePicture != nil {
                                Image(uiImage: profilePictureVM.profilePicture!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .font(.custom("Poppins-SemiBold", size: 20))
                                    .foregroundColor(.white)
                            } else {
                                Circle()
                                    .fill(Color(hexString: self.profilePicColorBackground) ?? Color(AppColors.purple))
                                    .frame(width: 40, height: 40)
                                // first 2 letters of username
                                    .overlay(
                                        Text(username.prefix(2))
                                            .font(.custom("Poppins-SemiBold", size: 20))
                                            .foregroundColor(.white)
                                    )
                            }
                        } else {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 40, height: 40)
                        }
                        
                        
                        Text("@\(self.username)")
                            .foregroundColor(.black)
                            .modifier(Poppins(fontWeight: AppFont.regular, .caption))
                        
                        
                    }
                    .padding(7)
                    .background(
                        Capsule()
                            .fill(Color.gray.opacity(0.15))
                            .shadow(color: Color.black.opacity(0.2), radius: 60, x: 0.0, y: 16)
                    )
                    
                }
                .padding(.horizontal)
                ScrollView(.vertical, showsIndicators: false) {
                    
                    // geo reader to calcualte postiion to animate arrow
                    GeometryReader { reader -> AnyView in
                        
                        DispatchQueue.main.async {
                            if refresh.startOffset == 0 {
                                refresh.startOffset = reader.frame(in: .global).minY
                            }
                            
                            refresh.offset = reader.frame(in: .global).minY
                            
                            if refresh.offset - refresh.startOffset > 60 && !refresh.started {
                                refresh.started = true
                            }
                            
                            // check if refresh ui started and drag is released
                            
                            if refresh.startOffset == refresh.offset && refresh.started && !refresh.released {
                                withAnimation(Animation.linear) {
                                    refresh.released = true
                                }
                                // update data here
                                updateData()
                            }
                            
                            // check if invalid scrolling becomes valid
                            if refresh.startOffset == refresh.offset && refresh.started && !refresh.released  && refresh.invalidScroll {
                                refresh.invalidScroll = false
                                updateData()
                            }
                            
                            
                        }
                        
                        //                    print(reader.frame(in: .global).minY)
                        return AnyView(Color.black.frame(width: 0, height: 0))
                    }
                    .frame(width: 0, height: 0)
                    
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                        
                        // arrow + indicator
                        
                        if refresh.started && refresh.released {
                            ProgressView()
                                .offset(y: -35)
                        } else {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(Color.gray)
                                .rotationEffect(.init(degrees: refresh.started ? 180 : 0))
                                .offset(y: -25)
                                .animation(Animation.linear)
                        }
                        
                        VStack(spacing: 15) {
                            
                            ForEach(posts.dataArray, id: \.self) { post in
                                PostView(post: post)
                            }
                            
                        }
                    }
                    .offset(y: refresh.released ? 40 : -10)
                    
                }
                .padding(.vertical)
                .padding(.top, 5)
            }
        }
        
        
    }
    
    func updateData() {
        print("updating data")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(Animation.linear) {
                if refresh.startOffset == refresh.offset {
                    posts.fetchPosts { finished in
                        print("finished")
                        refresh.released = false
                        
                        refresh.started = false
                    }
                    
                } else {
//                    refresh.invalidScroll = true
                }
            }
        }
    }
    
    
}

//struct HomeFeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeFeedView()
//    }
//}
