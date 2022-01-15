//
//  EditView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/14.
//

import SwiftUI

enum ContentType {
    case media, string
}

struct Topic: Identifiable {
    let id = UUID()
    let title: String
    let type: ContentType
}

struct EditView: View {
    
    var topics: [Topic] = [
        Topic(title: "What I thought today", type: .string),
        Topic(title: "What I ate today", type: .media),
        Topic(title: "What I saw today", type: .media),
        Topic(title: "What to do tomorrow", type: .string)
    ]
    
    var body: some View {
        List(topics) { topic in
            Section(topic.title) {
                if topic.type == .media {
                    VStack {
                        PhotoEditView()
                            .frame(height: 125)
                    }
                }
                
                if topic.type == .string {
                    Text(topic.title)
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
