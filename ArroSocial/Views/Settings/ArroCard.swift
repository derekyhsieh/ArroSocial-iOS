//
//  CardView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/30/22.
//

import SwiftUI

struct ArroCard<Front, Back>: View where Front: View, Back: View {
    var front: () -> Front
    var back: () -> Back
    
    @State var flipped: Bool = false
    @State var flashcardRotation = 0.0
    @State var contentRotation = 0.0
    
    init(@ViewBuilder front: @escaping() -> Front, @ViewBuilder back: @escaping() -> Back) {
        self.front = front
        self.back = back
    }
    
    var body: some View {
        ZStack {
            if flipped {
                back()
            } else {
                front()
            }
        }
        .rotation3DEffect(.degrees(contentRotation), axis: (x: 0, y: 1, z: 0))
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(
//                .stroke(Color(AppColors.purple), lineWidth: 2)
            AnimatedBackground()
                
        )
        .cornerRadius(20)

        .onTapGesture {
            flipFlashcard()
        }
        .rotation3DEffect(.degrees(flashcardRotation), axis: (x: 0, y: 1, z: 0))
    }
    
    func flipFlashcard() {
        let animationTime = 0.3
        withAnimation(Animation.linear(duration: animationTime)) {
            flashcardRotation += 180
        }
        
        withAnimation(Animation.linear(duration: 0.001).delay(animationTime / 2)) {
            contentRotation += 180
            flipped.toggle()
        }
    }
}

struct CardBack: View {
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String = ""
    var body: some View {
        VStack {
            Text(currentUserID)
                .font(.custom("Inconsolata", size: 20))
                .foregroundColor(.white)
            
        }
    }
}

struct CardFront: View {
    @AppStorage(CurrentUserDefaults.fName) var fName: String = ""
    
    @AppStorage(CurrentUserDefaults.lName) var lName: String = ""
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                    Text("ArroSocial")
                        .modifier(Poppins(fontWeight: AppFont.medium, .callout))
                        .foregroundColor(Color.white)
                    
                }
                //                       Text(currentUserID)
                //                            .font(.custom("Inconsolata", size: 18))
                //                            .fontWeight(.bold)
                //                            .foregroundColor(.white)
                Spacer()
                
                HStack {
                    Spacer(minLength: 0)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CARD HOLDER")
                            .font(.custom("Inconsolata", size: 15))
                            .foregroundColor(.gray)
                        Text(fName + " " + lName)
                            .font(.title2)
                        .font(.custom("Inconsolata", size: 20))
                    }
                    
                }
                .foregroundColor(Color.white)
                
            }
            .padding()
            
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardFront()
    }
}
