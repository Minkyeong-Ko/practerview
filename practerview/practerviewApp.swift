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
            NavigationView {
                MainView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            
        // https://stackoverflow.com/questions/29825604/how-to-save-array-to-coredata 코어데이터 배열
            
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
