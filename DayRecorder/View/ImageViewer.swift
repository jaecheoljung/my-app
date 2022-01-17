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
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 150 {
                        isPresented.toggle()
                    }
                }
        )
    }
}

struct ImageViewer_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewer(isPresented: .constant(true), image: UIImage(named: "iu")!)
    }
}
