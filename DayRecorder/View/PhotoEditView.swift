//
//  PhotoEditView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/15.
//

import SwiftUI

class PhotoEditViewModel: ObservableObject {
    var sourceType: UIImagePickerController.SourceType = .camera
    var pickerImage: UIImage?
    var viewerImage: UIImage?
}

struct PhotoEditView: View {
    
    @State var isPresented = false
    @ObservedObject var model = PhotoEditViewModel()
    @Binding var images: [UIImage]
    
    var body: some View {
        GeometryReader { geometryProxy in
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(images.indices, id: \.self) { idx in
                            Image(uiImage: images[idx])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometryProxy.size.height, height: geometryProxy.size.height)
                                .cornerRadius(4)
                                .onTapGesture {
                                    model.viewerImage = images[idx]
                                    isPresented.toggle()
                                }
                        }
                        
                        Menu(content: {
                            Button("Camera") {
                                model.sourceType = .camera
                                isPresented.toggle()
                            }
                        
                            Button("Album") {
                                model.sourceType = .photoLibrary
                                isPresented.toggle()
                            }
                        }) {
                            ZStack {
                                Color.black.opacity(0.05)
                                
                                Text("Add New Photo")
                                    .opacity(0.7)
                                    .padding(20)
                            }
                        }
                        .id("photo-edit-button")
                        .frame(width: geometryProxy.size.height, height: geometryProxy.size.height)
                        .cornerRadius(4)
                    }
                }
                .onAppear {
                    scrollProxy.scrollTo("photo-edit-button", anchor: .trailing)
                }
                .fullScreenCover(isPresented: $isPresented) {
                    if let image = model.pickerImage {
                        images.append(image)
                    }
                    model.pickerImage = nil
                    model.viewerImage = nil
                } content: {
                    if let image = model.viewerImage {
                        ImageViewer(
                            isPresented: $isPresented,
                            image: image
                        )
                    } else {
                        ImagePicker(
                            isPresented: $isPresented,
                            image: $model.pickerImage,
                            sourceType: model.sourceType
                        )
                    }
                }
            }
        }
    }
}

struct PhotoEditView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoEditView(images: .constant([UIImage(named: "iu")!]))
            .frame(height: 300)
    }
}
