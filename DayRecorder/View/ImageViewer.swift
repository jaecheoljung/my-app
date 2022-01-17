//
//  ImageViewer.swift
//  DayRecorder
//
//  Created by USER on 2022/01/16.
//

import SwiftUI

struct ImageViewer: View {
    
    @Binding var isPresented: Bool
    
    var image: UIImage
    
    var body: some View {
        ZStack {
            Color.black
            
            Image(uiImage: image)
        }
        .edgesIgnoringSafeArea(.all)
        .overlay(
            Button("Close") {
                isPresented.toggle()
            },
            alignment: .top
        )
    }
}

struct ImageViewer_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewer(isPresented: .constant(true), image: UIImage(named: "iu")!)
    }
}
