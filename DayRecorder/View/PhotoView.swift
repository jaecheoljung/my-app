//
//  PhotoView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/15.
//

import SwiftUI

struct PhotoView: View {
    
    var images: [UIImage]
    
    var body: some View {
        GeometryReader { proxy in
            TabView {
                ForEach(images.indices, id: \.self) { idx in
                    ImageView(image: images[idx])
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
        }
        .cornerRadius(4)
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(images: Array(repeating: UIImage(named: "iu")!, count: 2))
            .frame(width: 250, height: 100, alignment: .center)
    }
}
