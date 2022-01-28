//
//  PhotoEditView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/15.
//

import SwiftUI

struct PhotoEditView: View {
    
    @ObservedObject var item: DayRecordItem
    @State var isPresented = false
    @State var cameraPhoto: UIImage?
    @State var albumPhoto: UIImage?
    @State var viewerPhoto: UIImage?
    @State var isDisplayingDialog = false
    @State var selectedIndex: Int!
    @State var sourceType: UIImagePickerController.SourceType = .camera
    var photos: [UIImage] { item.photos }
    
    var body: some View {
        GeometryReader { geometryProxy in
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(photos.indices, id: \.self) { idx in
                            ImageView(image: photos[idx])
                                .frame(width: geometryProxy.size.height, height: geometryProxy.size.height)
                                .cornerRadius(4)
                                .onLongPressGesture {
                                    selectedIndex = idx
                                    isDisplayingDialog.toggle()
                                }
                        }
                        Menu(content: {
                            Button {
                                sourceType = .camera
                                isPresented.toggle()
                            } label: {
                                Label("take.photo".localized, systemImage: "camera")
                            }
                            
                            Button {
                                sourceType = .photoLibrary
                                isPresented.toggle()
                            } label: {
                                Label("retrieve.from.album".localized, systemImage: "photo.on.rectangle.angled")
                            }
                        }) {
                            ZStack {
                                Color.black.opacity(0.05)
                                
                                Label("add.new.photo".localized, systemImage: "photo")
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
                    if let image = albumPhoto {
                        item.photos.append(image)
                    }
                    albumPhoto = nil
                } content: {
                    ImagePicker(
                        isPresented: $isPresented,
                        image: $albumPhoto,
                        sourceType: sourceType
                    )
                }
                .confirmationDialog("alert.delete.photo".localized, isPresented: $isDisplayingDialog, titleVisibility: .visible) {
                    Button("delete.button".localized, role: .destructive) {
                        item.photos.remove(at: selectedIndex)
                    }
                }
            }
        }
    }
}
