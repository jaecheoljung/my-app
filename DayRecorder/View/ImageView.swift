//
//  ImageView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/18.
//

import SwiftUI

struct ImageView: View {
    @State var isPresented = false
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onTapGesture {
                isPresented.toggle()
            }
            .fullScreenCover(isPresented: $isPresented) {
                
            } content: {
                ImageViewer(
                    isPresented: $isPresented,
                    image: image
                )
            }
    }
}
