//
//  AnimatedBackground.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/31/22.
//

import SwiftUI
import Foundation

struct AnimatedBackground: View {
    @State var start = UnitPoint(x: 0, y: -2)
    @State var end = UnitPoint(x: 4, y: 0)
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    @State private var colors: [Color] = []
    
    
    var body: some View {
            
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .animation(Animation.easeInOut(duration: 7).repeatForever()).onReceive(timer) { _ in
                self.start = UnitPoint(x: 4, y: 0)
                self.end = UnitPoint(x: 0, y: 4)
                self.start = UnitPoint(x: 2, y: 5)
                self.start = UnitPoint(x: 4, y: 3)
            }
            .onAppear {
                
                populateColorsWithRandom()
            }
            
           
        
    }
    
    func populateColorsWithRandom() {
        for _ in 1...3 {
            colors.append(Color.random())
        }
        
    }
}



struct AnimatedBackground_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedBackground()
    }
}
