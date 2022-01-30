//
//  PhotoEditView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/15.
//

import SwiftUI
import Photos

class PhotoEditViewModel: ObservableObject {
    var pickerImage: UIImage?
    var selectedIndex: Int?
    var sourceType: ImagePicker.Source?
}

struct PhotoEditView: View {
    @ObservedObject var item: DayRecordItem
    @State var isDisplayingDialog = false
    @State var isPresented = false
    @ObservedObject var model = PhotoEditViewModel()
    
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
                                    model.selectedIndex = idx
                                    isDisplayingDialog.toggle()
                                }
                        }
                        Menu(content: {
                            Button {
                                model.sourceType = .camera
                                isPresented = true
                            } label: {
                                Label("take.photo".localized, systemImage: "camera")
                            }
                            
                            Button {
                                model.sourceType = .photoLibrary
                                isPresented = true
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
                        .id("add-button")
                        .frame(width: geometryProxy.size.height, height: geometryProxy.size.height)
                        .cornerRadius(4)
                    }
                }
                .onAppear {
                    scrollProxy.scrollTo("add-button", anchor: .trailing)
                }
                .fullScreenCover(isPresented: $isPresented) {
                    if let image = model.pickerImage {
                        item.photos.append(image)
                    }
                    model.pickerImage = nil
                } content: {
                    if let type = model.sourceType {
                        ImagePicker(
                            isPresented: $isPresented,
                            image: $model.pickerImage,
                            sourceType: type
                        )
                            .edgesIgnoringSafeArea(.all)
                    }
                }
                .confirmationDialog("alert.delete.photo".localized, isPresented: $isDisplayingDialog, titleVisibility: .visible) {
                    Button("delete.button".localized, role: .destructive) {
                        if let idx = model.selectedIndex {
                            item.photos.remove(at: idx)
                            model.selectedIndex = nil
                        }
                    }
                }
            }
        }
    }
}
