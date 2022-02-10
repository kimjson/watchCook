//
//  watchCookApp.swift
//  watchCook
//
//  Created by 김재성 on 2022/01/30.
//

import SwiftUI

@main
struct watchCookApp: App {
    @StateObject var dataController = DataController.shared // StateObject 로 감싸주면 preview 에서 실행되는 것을 막을 수 있음
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
