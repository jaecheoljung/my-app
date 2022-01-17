//
//  DayRecorderView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/14.
//

import SwiftUI

struct DayRecorderView: View {
    
    @Environment(\.managedObjectContext) var managadObjectContext
    @EnvironmentObject var model: DayRecorder
    @State var records: [DayRecord]
    @State var isPresented = false
    
    var body: some View {
        NavigationView {
            List(records) { record in
                Section(header: Text(record.dateString)) {
                    VStack(spacing: 20) {
                        NavigationLink(destination: {
                            DayView()
                        }) {
                            Text(record.title ?? "-")
                        }
                        
                        if record.images.count > 0 {
                            PhotoView(images: record.images)
                                .frame(height: 125)
                        }
                    }
                }
            }
            .navigationTitle("DayRecorder")
            .toolbar(content: { Button("Create", action: {
                isPresented.toggle()
            }) })
            .sheet(isPresented: $isPresented) {
                
            } content: {
                EditView(items: model.editingRecord!.editItemArray, isPresented: $isPresented)
            }
        }
    }
}

struct DayRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        DayRecorderView(records: [])
    }
}


extension DayItem {
    var photos: [UIImage] {
        get { content as? [UIImage] ?? [] }
        set { content = newValue as NSObject }
    }
    
    var text: String {
        get { content as? String ?? "-" }
        set { content = newValue as NSObject }
    }
}

extension DayRecord {
    var images: [UIImage] {
        itemArray.flatMap(\.photos)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date!)
    }
    
    var itemArray: [DayItem] {
        items?.array as? [DayItem] ?? []
    }
    
    var editItemArray: [EditItem] {
        itemArray.compactMap {
            if $0.content is String {
                return EditItem(title: $0.title!, photos: [], text: $0.content as! String, type: .text)
            }
            if $0.content is [UIImage] {
                return EditItem(title: $0.title!, photos: $0.content as! [UIImage], text: "-", type: .photo)
            }
            return nil
        }
    }
}
