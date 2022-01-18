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
        VStack(alignment: .trailing) {
            TextEditor(text: $item.text)
                .opacity(0.85)
            
            Text("\(item.text.count) / 150")
                .opacity(0.6)
                .font(.footnote)
        }
        .onChange(of: item.text) { _ in
            item.text = String(item.text.prefix(150))
        }
    }
}
