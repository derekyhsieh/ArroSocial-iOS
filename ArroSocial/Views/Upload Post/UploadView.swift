//
//  UploadView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/8/22.
//

import SwiftUI

struct UploadView: View {
 
    
    @State private var caption = ""
    @AppStorage(CurrentUserDefaults.username) var username: String?
    @AppStorage(CurrentUserDefaults.profilePicColor) var profilePicColor: String = ""
    @State private var postImage: UIImage = UIImage(named: "placeholder")!
    @State private var isShowingPhotoPicker: Bool = false
    @State private var isShowingTextEditorPlaceholder: Bool = true
    
    
    var body: some View {
        VStack {
            Text("Upload Post")
                .font(.custom("Poppins-Medium", size: 30))
            
            
            ZStack(alignment: .trailing) {
                VStack {
                    
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            Circle()
                                .fill(Color(hexString: self.profilePicColor) ?? Color(AppColors.purple))
                                .frame(width: 50, height: 50)
                            // first 2 letters of username
                                .overlay(
                                    Text((username ?? "  ").prefix(2) )
                                        .font(.custom("Poppins-SemiBold", size: 20))
                                        .foregroundColor(.white)
                                )
                            Text("@" + (self.username ?? ""))
                                .foregroundColor(.white)
                                .modifier(Poppins(fontWeight: AppFont.semiBold, .subheadline))
                            
                            Spacer()
                        }
                        
                        if self.caption != "" {
                            Text(self.caption)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color.white)
                                .modifier(Poppins(fontWeight: AppFont.medium, .caption))
                                .frame(height: 50)
                                .truncationMode(.tail)
                                .padding(-5)
                        }
                        
                    }
                    .padding()
                    
                    .frame(maxWidth: UIScreen.main.bounds.width - 20)
                    //                .shadow(color: Color.black, radius: 15, x: 0, y: -10)
                    .shadow(color: Color.black.opacity(0.4), radius: 30, x: 0.0, y: 5)
                }
                
            }
            .frame(width: UIScreen.main.bounds.width - 20, height: 400)
            .background(
                Image(uiImage: postImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .overlay(
                
                
                Image(systemName: "arrow.up.doc.fill")
                //                    .resizable()
                //                    .aspectRatio(contentMode: .fill)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.8))
                
            )
            .cornerRadius(30)
            .onTapGesture {
                self.isShowingPhotoPicker = true
            }
            
            
//            TextEditor(text: $caption)
//                .padding()
//                .font(.body)
//                .foregroundColor(.white) // Text color
//                .background(Color.blue) // TextEditor's Background Color
//                .cornerRadius(30)
//                .padding()

            ZStack(alignment: .topLeading) {
                if (caption.isEmpty || self.isShowingTextEditorPlaceholder){
                    Text("Caption")
                        .font(.custom("Poppins-Regular", size: 24))
                        .padding(.all)
                        .foregroundColor(.gray)
                }
                
                TextEditor(text: $caption)
                    .opacity(caption.isEmpty ? 0.25 : 1)
                    .font(.custom("Poppins-Regular", size: 24))
                    .padding(.all)
                    .onTapGesture {
                        self.isShowingTextEditorPlaceholder = false
                    }
                    .offset(y: -10)
                 
            }
            
            
            
            Spacer(minLength: 0)
            Button(action: {}) {
                Text("Post")
                    .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(AppColors.purple))
                    .cornerRadius(50)
                    .padding(.horizontal)
                    .opacity(self.postImage == UIImage(named: "placeholder")! ? 0.4 : 1)
                    .disabled(self.postImage == UIImage(named: "placeholder")! ? true : false)
            }
            
        }
        .sheet(isPresented: $isShowingPhotoPicker) {
            PhotoPicker(image: $postImage)
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
