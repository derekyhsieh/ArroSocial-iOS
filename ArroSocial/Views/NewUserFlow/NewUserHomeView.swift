//
//  NewUserHome.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/28/22.
//

import SwiftUI

struct NewUserHomeView: View {
    @Binding var isShowingNewUserWalkthrough: Bool
    @Binding var isShowingWelcome: Bool
    var screenSize: CGSize
    @State var username: String = ""
    @State var offset: CGFloat = 0
    @State private var indexNumber = 0
    @State private var isDeletingUser: Bool = false
    
    var body: some View {
        ZStack {
        VStack {
            
            Button(action: {
                
                self.deleteUser()
           
            }) {
                Image("arro-logo")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(pages[getIndex()].color)
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            OffsetPageTabView(offset: $offset) {
                
                
                
                HStack(spacing: 0) {
                    VStack {
                            UsernameSubmissionView(username: $username, color: pages[0].color)
                            .padding(.top, 50 )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .frame(width: screenSize.width)
                    
                    VStack {
                        FirstLastNameSubmission(color: pages[1].color)
                        .padding(.top, 50 )
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .frame(width: screenSize.width)
                    
                    VStack {
                        ProfilePictureSubmission(username: $username, color: pages[2].color)
                        .padding(.top, 50 )
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .frame(width: screenSize.width)
                    
                }
            }
            // animated paging indicator
            HStack(alignment: .bottom) {
                
                HStack(spacing: 12) {
                    ForEach(pages.indices, id: \.self) { index in
                        Capsule()
                            .fill(pages[getIndex()].color)
                        // changes width only for current index
                            .frame(width: getIndex() == index ? 20 : 7, height: 7)
                        
                    }
                }
                .overlay(
                    Capsule()
                        .fill(pages[getIndex()].color)
                        .frame(width: 20, height: 7)
                        .offset(x: getIndicatorOffset())
                    , alignment: .leading
                )
                .offset(y: -15)
                .padding()
                
                Spacer()
                
                // TODO: FIX BUG FOR END //////////
                
                Button(action: {
                    // update offset
                    let index = min(getIndex() + 1, pages.count - 1)
                    offset = CGFloat(index) * screenSize.width
                    
                    // need to find when user is at end of walkthrough
                    if(index == 2 || offset == screenSize.width * 2) {
                        indexNumber += 1
                    }
                    print(index)
                    // need to have top if statemnet run twice in order for the paging view to be done
                    if(indexNumber >= 2 && index == 2) {
                        print("ENDED")
                        withAnimation {
                            self.isShowingWelcome = false
                        }
                    }
                    hideKeyboard()
                    
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2.bold())
                        .foregroundColor(Color.white)
                        .padding(20)
                        .background(
                            pages[getIndex()].color,
                            in: Circle()
                            
                        )
                }
                .padding()
                //                .offset(y: -20)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        // animating when index changes
        .animation(.easeInOut, value: getIndex())
            if isDeletingUser {
                ProgressView("Deleting Account...")
                    .padding()
                    .padding()
                    .padding()
                    .scaleEffect(1.5, anchor: .center)
                    .accentColor(Color(AppColors.purple))
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 60, x: 0, y: 0)
                    )
            }
       
        }
        
    }
    
    // custom offset for indicators (bottom left)
    func getIndicatorOffset() -> CGFloat {
        let progress = offset / screenSize.width
        
        // 12 is spacing 7 is circle size (12+7=19)
        let maxWidth: CGFloat = 19
        
        return progress * maxWidth
    }
    
    // changes index based on offset of paging view
    func getIndex() -> Int {
        // schoolbook rounding (ex: 1.1 => 1, 3.8 => 4, 2.5 => 3)
        let progress = round(offset / screenSize.width)
        
        // error handling
        let index = min(Int(progress), pages.count - 1)
        return (index)
    }
    
    func deleteUser() {
        AuthenticationService.instance.deleteUser(hasUserCompletedOnboarding: false, userHasData: false) { error in
            if let error = error {
                // error present
                print(error)
            } else {
                // success
                withAnimation {
                    self.isDeletingUser = false
                    self.isShowingNewUserWalkthrough = false
                }
            }
        }
    }
}

//struct NewUserHome_Previews: PreviewProvider {
//    static var previews: some View {
//        // get screen size
//        GeometryReader { proxy in
//            let size = proxy.size
//
//            NewUserHomeView(screenSize: size)
//        }
//    }
//}
