//
//  TextEditView.swift
//  DayRecorder
//
//  Created by USER on 2022/01/15.
//

import SwiftUI

struct TextEditView: View {
    
    @ObservedObject var item: DayRecordItem
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if item.text.isEmpty {
                Text("내용을 입력하세요")
                    .opacity(0.3)
                    .padding(.top, 7)
                    .padding(.leading, 4)
            }
            
            VStack(alignment: .trailing) {
                TextEditor(text: $item.text)
                    .opacity(0.85)
                
                Text("\(item.text.count) / 150")
                    .opacity(0.6)
                    .font(.footnote)
            }
            .background(Color.clear)
        }
        .onChange(of: item.text) { _ in
            item.text = String(item.text.prefix(150))
        }
    }
}
