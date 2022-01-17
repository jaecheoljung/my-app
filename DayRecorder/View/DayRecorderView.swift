//
//  DayRecorderView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/14.
//

import SwiftUI

struct DayRecorderView: View {
    
    @Environment(\.managedObjectContext) var managadObjectContext
    @FetchRequest(
        entity: DayRecord.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \DayRecord.date, ascending: false)
        ],
        predicate: NSPredicate(format: "isEditing != TRUE")
    ) var records: FetchedResults<DayRecord>
    
    @State var isPresent = false
    
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
                isPresent.toggle()
            }) })
            .sheet(isPresented: $isPresent) {
                
            } content: {
                EditView()
            }
        }
    }
}

struct DayRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        DayRecorderView()
            .environment(\.managedObjectContext, PersistanceController.preview.container.viewContext)
    }
}


extension DayItem {
    var photos: [UIImage] {
        content as? [UIImage] ?? []
    }
}

extension DayRecord {
    var images: [UIImage] {
        guard let items = items?.array as? [DayItem] else {
            return []
        }
        return items.flatMap(\.photos)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date!)
    }
}
