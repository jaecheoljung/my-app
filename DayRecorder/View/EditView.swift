//
//  EditView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/14.
//

import SwiftUI

struct EditView: View {
    
    @EnvironmentObject var recorder: DayRecorder
    
    var items: [DayItem] {
        (recorder.editingRecord?.items?.array as? [DayItem]) ?? []
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            List {
                ForEach(items) { item in
                    Section(item.title ?? "-") {
                        if let images = item.content as? [UIImage] {
                            PhotoEditView(images: images)
                                .frame(height: 160)
                        }
                        if let text = item.content as? String {
                            TextEditView(text: text)
                                .frame(height: 160)
                        }
                    }
                }
                
                Button("Save") {
                    
                }
                
                Button("Cancel") {
                    
                }
                .foregroundColor(.red)
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
            .environment(\.managedObjectContext, PersistanceController.preview.container.viewContext)
            .environmentObject(DayRecorder())
    }
}
