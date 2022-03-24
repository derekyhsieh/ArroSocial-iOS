//
//  SplashScreen.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/13/22.
//

import SwiftUI

struct SplashScreen: View {
    @State private var animate = false
    @State private var endSplash = false
    
    var body: some View {
        ZStack {
            if animate {
                Color(AppColors.bg)
            } else {
                Color("purple")
            }
            
            
            Image("logo")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: animate ? .fill :  .fit)
                .frame(width: animate ? nil : 120, height: animate ? nil : 120)
            // scaling view
                .scaleEffect(animate ? 10 : 1)
            // set width to avoid oversizing
                .frame(width: UIScreen.main.bounds.width, height: 100)
        }
        .ignoresSafeArea(.all, edges: .all)
        .onAppear {
            animateSplash()
        }
        // hiding view after finished
        .opacity(endSplash ? 0 : 1)
    }
    
    func animateSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(Animation.easeOut(duration: 0.45)) {
                animate.toggle()
            }
            withAnimation(Animation.easeOut(duration: 0.35)) {
                endSplash.toggle()
            }
        }
      
    }

    
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
