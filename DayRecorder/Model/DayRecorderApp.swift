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
    let controller = PersistanceController.shared
    
    var body: some Scene {
        WindowGroup {
            DayRecorderView()
                .environment(\.managedObjectContext, controller.context)
        }
        
        .onChange(of: scenePhase) { newValue in
            controller.save()
        }
    }
}


extension String {
    var localized: Self {
        NSLocalizedString(self, comment: "")
    }
    
    func localized(_ args: CVarArg...) -> Self {
        String(format: localized, arguments: args)
    }
}
