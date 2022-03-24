//
//  HomeView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/23/22.
//

import SwiftUI

var tabs = [AppPages.home, AppPages.messages, AppPages.search, AppPages.settings]

struct AppWrapperView: View {
    @State var selectedTab = tabs[0]
    @State private var showPermissionsModal: Bool = false
    @State private var isShowingUploadView: Bool = false
    @State var tabBarCenter: CGFloat = 0
    @State private var profileImage: UIImage = UIImage(named: "arro")!
    @State private var isFinishedLoadingData: Bool = false
    @StateObject var profilePicVM: ProfilePictureViewModel
    
    
    @AppStorage(CurrentUserDefaults.profilePicColor) var profilePicColor: String = ""
    @AppStorage("gottenUserPermissions") var gottenUserPermissions: Bool = false
    @AppStorage(CurrentUserDefaults.userID) var userID: String = ""
    @Namespace var animation
    @State private var isShowingProfileView: Bool = false
    
    
    
    // full screen posts view
    
    @State var show = false
    @State var selectedPost: FullScreenPostModel? = nil
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                TabView(selection: $selectedTab) {
                    
                    HomeFeedView(profilePictureVM: profilePicVM, isShowingUploadView: $isShowingUploadView, showPermissionsModal: $showPermissionsModal, isShowingProfileView: $isShowingProfileView, selectedPost: $selectedPost, show: $show, namespace: namespace, posts: PostsViewModel(currentUserID: self.userID))
                        .tag(tabs[0])
                        .ignoresSafeArea(.all, edges: [.leading, .trailing, .bottom])
                    Color.blue
                        .overlay(Text(tabs[1]))
                        .tag(tabs[1])
                        .ignoresSafeArea(.all, edges: .all)
                    Color.yellow
                        .overlay(Text(tabs[2]))
                        .tag(tabs[2])
                        .ignoresSafeArea(.all, edges: .all)
                    SettingsView(profilePictureVM: self.profilePicVM, selectedTab: $selectedTab)
                        .tag(tabs[3])
                        .ignoresSafeArea(.all, edges: [.leading, .trailing])
                }
                
                HStack(spacing: 0) {
                    ForEach(tabs, id: \.self) { image in
                        
                        GeometryReader { reader in
                            Button(action: {
                                withAnimation(.spring()) {
                                    self.selectedTab = image
                                    tabBarCenter = reader.frame(in: .global).minX
                                }
                            }) {
                                Image(systemName: image)
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .modifier(Poppins(fontWeight: selectedTab == image ? AppFont.semiBold : AppFont.medium))
                                    .foregroundColor(selectedTab == image ? Color(AppColors.purple) : Color.gray)
    //                                .fontWeight(selectedTab == image ? .bold : .none)
                                    .padding(selectedTab == image ? 15 : 0)
                                    .background(Color(.white).opacity(selectedTab == image ? 1 : 0))
                                    .matchedGeometryEffect(id: image, in: animation)
                                    .clipShape(Circle())
                                    .offset(x: reader.frame(in: .global).minX - reader.frame(in: .global).midX ,y: selectedTab == image ? -42 : 0)
                                    .overlay(
                                        // make clickable area bigger so it's easier to tap on tab bar buttons
                                        Circle()
                                            .fill(Color.clear)
                                            .frame(width: 75, height: 75)
                                            .offset(y: 10)
                                    )
                                
                            }
                            .onAppear() {
                                if image == tabs.first {
                                    tabBarCenter = reader.frame(in: .global).minX
                                }
                            }
                        }
                        
                        .frame(width: 25, height: 25)
                        
                        if image != tabs.last{
                            // dynamically render spacing
                            Spacer(minLength: 0)
                        }
                    }
                }
                .padding(.horizontal , 30)
                .padding(.vertical)
                .background(Color(.white).clipShape(CurveShape(center: tabBarCenter)).cornerRadius(12))
                .padding(.horizontal)
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                .shadow(color: Color.black.opacity(0.1), radius: 70, x: -10, y: 0)
                .shadow(color: Color.black.opacity(0.1), radius: 60, x: 0, y: 10)
            }
            .ignoresSafeArea(.all, edges: .bottom)
           
            .JMAlert(showModal: $showPermissionsModal, for: [.camera, .photo], autoDismiss: true, onAppear: {
                print("permissions alert appeared")
            }, onDisappear: {
                gottenUserPermissions = true
                self.isShowingUploadView = true
            })
    //        .JMAlert(showModal: $showPermissionsModal, for: [.camera, .photo], autoDismiss: true, autoCheckAuthorization: true, onDisappear(perform: {
    //        }))
            .sheet(isPresented: $isShowingUploadView) {
                UploadView(profilePicVM: self.profilePicVM)
                  }
            .sheet(isPresented: $isShowingProfileView, content: {
                ProfileView(isUsersOwnProfile: true, profilePosts: PostsViewModel(userID: userID), profilePictureVM: self.profilePicVM, selectedPost: $selectedPost)
                    
            })
            
            .onAppear {
                print("appeared")
                profilePicVM.fetchData()
            }
            
            // full screen
        
            
            if selectedPost != nil  && profilePicVM.isFinishedFetchingProfilePicture {
                VStack {
                    FullScreenPostView(post: self.$selectedPost, show: $show, namespace: namespace, currentUserProfileImage: (profilePicVM.profilePicture ?? UIImage(named: "placeholder"))!, currentUserProfileBackground: self.profilePicColor)
                .matchedGeometryEffect(id: "(selectedPost!.postID)", in: namespace)

                            
                    
                
                }
                .matchedGeometryEffect(id: "container\(selectedPost!.postID)", in: namespace)
                .edgesIgnoringSafeArea(.vertical)
//                .transition(
//                    .asymmetric(insertion:
//                                    AnyTransition.opacity.animation(Animation.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0).delay(0.3))
//                                , removal: AnyTransition.opacity.animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)))
//                )
//                
                .zIndex(2)
            }
            
            
        }
        
        
    }
}


//struct AppWrapperView_Preview: PreviewProvider {
//    static var previews: some View {
//        AppWrapperView()
//    }
//}


// tab view curve
struct CurveShape: Shape {
    
    var center: CGFloat
    var animatableData: CGFloat {
        get {return center}
        set{center = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let center = center
            
            path.move(to: CGPoint(x: center - 50, y: 0))
            
            let to1 = CGPoint(x: center, y: 35)
            let control1 = CGPoint(x: center - 30, y: 0)
            let control2 = CGPoint(x: center - 30, y: 35)
            
            let to2 = CGPoint(x: center + 50, y: 0)
            let control3 = CGPoint(x: center + 30, y: 35)
            let control4 = CGPoint(x: center + 30, y: 0)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}
