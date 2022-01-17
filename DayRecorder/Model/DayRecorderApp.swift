//
//  DayRecorderApp.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/14.
//

import SwiftUI

@main
struct DayRecorderApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var model = DayRecorder()
    let controller = PersistanceController.shared
    
    var body: some Scene {
        WindowGroup {
            DayRecorderView(records: (try? controller.fetch(isEditing: false)) ?? [])
                .environment(\.managedObjectContext, controller.context)
                .environmentObject(model)
        }
        .onChange(of: scenePhase) { newValue in
            controller.save()
        }
    }
}
