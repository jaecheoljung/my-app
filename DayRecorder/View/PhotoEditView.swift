//
//  PhotoEditView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/15.
//

import SwiftUI

class PhotoEditViewModel: ObservableObject {
    @Published var images = [UIImage]()
    var sourceType: UIImagePickerController.SourceType = .camera
    var pickerImage: UIImage?
    var viewerImage: UIImage?
}

struct PhotoEditView: View {
    
    @State var isPresented = false
    @ObservedObject var model = PhotoEditViewModel()
    
    init(images: [UIImage]) {
        model.images = images
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(model.images.indices) { idx in
                            Image(uiImage: model.images[idx])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometryProxy.size.height, height: geometryProxy.size.height)
                                .cornerRadius(4)
                                .onTapGesture {
                                    model.viewerImage = model.images[idx]
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
                        model.images.append(image)
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
        PhotoEditView(images: [UIImage(named: "iu")!])
            .frame(height: 300)
    }
}
