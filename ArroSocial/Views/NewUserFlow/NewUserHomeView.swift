//
//  NewUserHome.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/28/22.
//

import SwiftUI

struct NewUserHomeView: View {
    @Binding var isShowingNewUserWalkthrough: Bool
    var screenSize: CGSize
    @State var username: String = ""
    @State var offset: CGFloat = 0
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isShowingNewUserWalkthrough = false
                }
           
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
                
                Button(action: {
                    // update offset
                    let index = min(getIndex() + 1, pages.count - 1)
                    offset = CGFloat(index) * screenSize.width
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