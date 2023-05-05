//
//  practerviewApp.swift
//  practerview
//
//  Created by Minkyeong Ko on 2023/05/05.
//

import SwiftUI

@main
struct practerviewApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
