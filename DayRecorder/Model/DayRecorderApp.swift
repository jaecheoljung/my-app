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
    let persistanceController = PersistanceController.shared
    
    var body: some Scene {
        WindowGroup {
            DayRecorderView()
                .environment(\.managedObjectContext, PersistanceController.shared.container.viewContext)
                .environmentObject(DayRecorder())
        }
        .onChange(of: scenePhase) { newValue in
            persistanceController.save()
        }
    }
}
