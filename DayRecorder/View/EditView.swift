//
//  EditView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/14.
//

import SwiftUI


struct EditItem: Identifiable {
    enum ItemType {
        case media, string, button
    }
    let id = UUID()
    let title: String
    let type: ItemType
}

struct EditView: View {
    
    @State var mode = EditMode.inactive
    
    @State var items: [EditItem] = [
        EditItem(title: "What I thought today", type: .string),
        EditItem(title: "What I ate today", type: .media),
        EditItem(title: "What I saw today", type: .media),
        EditItem(title: "What to do tomorrow", type: .string),
        EditItem(title: "Edit", type: .button),
        EditItem(title: "Save", type: .button),
        EditItem(title: "Cancel", type: .button)
    ]
    
    var body: some View {
        List {
            ForEach(items) { item in
                if item.type == .button {
                    Button(item.title) {
                        mode = .active
                    }
                } else {
                    Section(item.title) {
                        if item.type == .media {
                            PhotoEditView()
                                .frame(height: 160)
                        }
                        
                        if item.type == .string {
                            TextEditView()
                                .frame(height: 160)
                        }
                    }
                }
            }
            .onDelete { offset in
                items.remove(atOffsets: offset)
            }
        }
        .environment(\.editMode, $mode)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
