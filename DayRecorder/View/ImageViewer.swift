//
//  ImageViewer.swift
//  DayRecorder
//
//  Created by USER on 2022/01/16.
//

import SwiftUI

struct ImageViewer: View {
    
    @State var currentScale: CGFloat = 1
    @State var previousScale: CGFloat = 1
    @State var currentOffset = CGSize.zero
    @State var previousOffset = CGSize.zero
    @Binding var isPresented: Bool
    var image: UIImage
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ZStack {
                    Color.black
                    
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(x: currentOffset.width, y: currentOffset.height)
                        .scaleEffect(max(currentScale, 1))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let deltaX = value.translation.width - previousOffset.width
                                    let deltaY = value.translation.height - previousOffset.height
                                    previousOffset.width = value.translation.width
                                    previousOffset.height = value.translation.height
                                    let newOffsetWidth = currentOffset.width + deltaX / currentScale
                                    if newOffsetWidth <= geometry.size.width - 150 && newOffsetWidth > -150 {
                                        currentOffset.width = currentOffset.width + deltaX / currentScale
                                    }
                                    currentOffset.height = currentOffset.height + deltaY / currentScale
                                }
                                .onEnded { value in
                                    if currentOffset.height > 150 {
                                        isPresented.toggle()
                                    }
                                    if currentScale == 1 {
                                        withAnimation {
                                            currentOffset = .zero
                                        }
                                    }
                                    previousOffset = CGSize.zero
                                }
                        )
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let delta = value / previousScale
                                    previousScale = value
                                    currentScale = currentScale * delta
                                }
                                .onEnded { value in
                                    previousScale = 1
                                }
                        )
                }
                
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .onTapGesture {
                        isPresented.toggle()
                    }
                    .offset(x: 16, y: geometry.safeAreaInsets.top + 16)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
