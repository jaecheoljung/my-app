//
//  PhotoEditView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/15.
//

import SwiftUI

struct PhotoEditView: View {
    
    var images: [String] = ["iu", "iu"]
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(0..<images.count) { idx in
                        Image(images[idx])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: proxy.size.height, height: proxy.size.height)
                            .cornerRadius(4)
                    }
                    
                    Button(action: {
                        
                    }) {
                        ZStack {
                            Color.black.opacity(0.05)
                            
                            VStack {
                                Text("Add New Photo")
                                    .opacity(0.7)
                            }
                            .padding(20)
                        }
                    }
                    .frame(width: proxy.size.height, height: proxy.size.height)
                    .cornerRadius(4)
                }
            }
        }
    }
}

struct PhotoEditView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoEditView()
            .frame(height: 300)
    }
}
