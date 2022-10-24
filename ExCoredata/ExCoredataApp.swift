//
//  ExCoredataApp.swift
//  ExCoredata
//
//  Created by 김종권 on 2022/10/24.
//

import SwiftUI

@main
struct ExCoredataApp: App {
  let viewContext = CoreDataStorage.shared.viewContext
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, viewContext)
    }
  }
}
