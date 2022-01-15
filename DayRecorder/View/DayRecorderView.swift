//
//  DayRecorderView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/14.
//

import SwiftUI

struct DayRecorderView: View {
    
    struct Day: Identifiable {
        let id = UUID()
        let title: String
        let semititle: String
    }
    
    private let mockDays = [
        Day(title: "First day", semititle: "First day semititle"),
        Day(title: "Second day", semititle: "Second day semititle"),
        Day(title: "Third day", semititle: "Third day semititle"),
    ]
    
    @State var isPresent = false
    
    var body: some View {
        NavigationView {
            List(mockDays) { day in
                Section(header: Text("2020-08-15")) {
                    VStack(spacing: 20) {
                        NavigationLink(destination: {
                            DayView()
                        }) {
                            Text(day.title)
                        }
                        
                        PhotoView(images: ["iu", "iu"])
                            .frame(height: 125)
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
    }
}
