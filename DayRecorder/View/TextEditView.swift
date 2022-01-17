//
//  TextEditView.swift
//  DayRecorder
//
//  Created by USER on 2022/01/15.
//

import SwiftUI

struct TextEditView: View {
    
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .trailing) {
            TextEditor(text: $text)
                .opacity(0.85)
            
            Text("\(text.count) / 150")
                .opacity(0.6)
                .font(.footnote)
        }
        .onChange(of: text) { _ in
            text = String(text.prefix(150))
        }
    }
}

struct TextEditView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditView(text: .constant("-"))
            .frame(height: 500)
    }
}
