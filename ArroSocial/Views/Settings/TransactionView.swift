//
//  TransactionView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/31/22.
//

import SwiftUI

struct TransactionView: View {
    var body: some View {
        VStack {
            ArroCard(front: {
                
                CardFront()
            }) {
                CardBack()
            }
            .shadow(color: Color.black.opacity(0.13), radius: 30, x: 0, y: 0)
        }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
    }
}
