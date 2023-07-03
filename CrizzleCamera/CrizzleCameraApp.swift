//
//  CrizzleCameraApp.swift
//  CrizzleCamera
//
//  Created by Christopher Turner on 7/2/23.
//

import SwiftUI

@main
struct CrizzleCameraApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
