//
//  TransactionView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/31/22.
//

import SwiftUI

struct TransactionView: View {
    @State var attempts: Int = 0
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                
                
                
                
                Spacer(minLength: 0)
                VStack {
                    HStack(alignment: .center){
                        
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(Color.black)
                                .font(.title2)
                        }
                        
                        
                        
                        
                        
                        Spacer(minLength: 0)
                        
                        (Text("Tokens: ")
                         
                            .foregroundColor(.gray)
                         
                         +
                         Text("\(1000)")
                            .foregroundColor(Color.black)
                        )
                        
                        .modifier(Poppins(fontWeight: AppFont.semiBold, .subheadline))
                        //                            .padding(.bottom, 30)
                        .lineLimit(1)
                        
                        Spacer(minLength: 0)
                    }
                    
                    Spacer()
                    ArroCard(front: {
                        
                        CardFront()
                    }) {
                        CardBack()
                    }
                    .shadow(color: Color.black.opacity(0.13), radius: 30, x: 0, y: 0)
                    
                    Spacer()
                    
                    Text("feature is still in development")
                        .foregroundColor(Color.red)
                        .font(.caption)
                    
                    Button(action: {
                        withAnimation {
                            self.attempts += 1
                        }
                    }) {
                        PrimaryButton(color: Color.green, title: "Deposit")
                            .modifier(Shake(animatableData: CGFloat(attempts)))
                    }
                    
                    
                    Button(action: {
                        withAnimation {
                            self.attempts += 1
                        }
                    }) {
                        PrimaryButton(title: "Withdraw")
                            .modifier(Shake(animatableData: CGFloat(attempts)))
                            .padding(.bottom, ((UIApplication.shared.windows.first?.safeAreaInsets.bottom)!) * 2 + 20)
                    }
                }
            }
            .padding()
            
            
            
            
        }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
    }
}
