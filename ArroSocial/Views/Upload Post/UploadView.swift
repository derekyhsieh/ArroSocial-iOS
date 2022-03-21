//
//  UploadView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/8/22.
//

import SwiftUI

struct UploadView: View {
    
    
    @State private var caption = ""
    @AppStorage(CurrentUserDefaults.userID) var userID: String?
    @AppStorage(CurrentUserDefaults.username) var username: String?
    @AppStorage(CurrentUserDefaults.profilePicColor) var profilePicColor: String = ""
    @State private var postImage: UIImage = UIImage(named: "placeholder")!
    @State private var isShowingPhotoPicker: Bool = false
    @State private var isShowingTextEditorPlaceholder: Bool = true
    @State private var isLoading: Bool = false
    @StateObject var profilePicVM: ProfilePictureViewModel
    @State var attempts: Int = 0
    
    private enum Field: Int, CaseIterable {
        case caption
    }
    
    @FocusState private var focusedField: Field?
    
    
    // for dismissing sheet
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Text("Upload Post")
                            .font(.custom("Poppins-Medium", size: 30))
                        Spacer()
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color.gray)
                                .padding(10)
                                .background(
                                    Circle()
                                        .fill(Color.black)
                                )
                        }
                    }
                    .padding()
                    
                    
                    ZStack(alignment: .trailing) {
                        VStack {
                            
                            Spacer()
                            VStack(alignment: .leading) {
                                HStack {
                                    
                                    
                                    if profilePicVM.isFinishedFetchingProfilePicture {
                                        
                                        if profilePicVM.profilePicture != nil {
                                            Image(uiImage: profilePicVM.profilePicture!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                        } else {
                                            Circle()
                                                .fill(Color(hexString: self.profilePicColor) ?? Color(AppColors.purple))
                                                .frame(width: 50, height: 50)
                                            // first 2 letters of username
                                                .overlay(
                                                    Text((username ?? "  ").prefix(2) )
                                                        .font(.custom("Poppins-SemiBold", size: 20))
                                                        .foregroundColor(.white)
                                                )
                                        }
                                        
                                        
                                        
                                    }
                                    
                                    
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
                            .foregroundColor(postImage == UIImage(named: "placeholder") ? Color.white.opacity(0.8) : Color.clear)
                        
                        
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
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                            .opacity(caption.isEmpty ? 0.25 : 1)
                            .font(.custom("Poppins-Regular", size: 24))
                            .padding(.all)
                            .onTapGesture {
                                self.isShowingTextEditorPlaceholder = false
                            }
                            .offset(y: -10)
                            .onChange(of: caption, perform: { value in
                                if value.count < 1 {
                                    caption = value.trimmingCharacters(in: .whitespacesAndNewlines)
                                }
                            })
                            .focused($focusedField, equals: .caption)
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    Spacer(minLength: 0)
                    Button(action: {
                        if self.postImage.isEqual(UIImage(named: "placeholder")!)  || self.caption.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                            withAnimation(.default) {
                                self.attempts += 1
                            }
                        } else {
                            uploadImage()
                        }
                    }) {
                        Text("Post")
                            .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(AppColors.purple))
                            .cornerRadius(50)
                            .padding(.horizontal)
                            .opacity((self.postImage == UIImage(named: "placeholder")! || self.caption.trimmingCharacters(in: .whitespacesAndNewlines) == "") ? 0.4 : 1)
                            .disabled(self.postImage == UIImage(named: "placeholder")! ? true : false)
                            .modifier(Shake(animatableData: CGFloat(attempts)))
                    }
                    
                }
                .sheet(isPresented: $isShowingPhotoPicker) {
                    PhotoPicker(image: $postImage)
                    
                }
                
                CustomLoadingIndicator(isShowing: $isLoading)
                
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text("Home"))
            .edgesIgnoringSafeArea([.top])
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    // dismiss keyboard
                    HStack {
                        Button("Done") {
                            focusedField = nil
                        }
                        Spacer()
                        
                    }
                }
            }
         
        }
        
    }
    
    func uploadImage() {
        // TODO: GET POST ID AND POST COUNT
        
        withAnimation {
            self.isLoading = true
        }
        
        // check if user put in a caption
        if caption.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            DataService.instance.uploadPost(image: self.postImage, caption: self.caption, userName: self.username!, userID: self.userID!) { success, postID in
                self.isLoading = false
                
                self.presentationMode.wrappedValue.dismiss()
                if(!success) {
                    // print error
                }
            }
        }
        
        
        
    }
    
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView(profilePicVM: ProfilePictureViewModel())
    }
}
