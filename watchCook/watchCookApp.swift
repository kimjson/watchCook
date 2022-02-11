//
//  watchCookApp.swift
//  watchCook
//
//  Created by 김재성 on 2022/01/30.
//

import SwiftUI

@main
struct watchCookApp: App {
    // watchOS 시뮬레이터에서 CloudKit 데이터를 가져올 수 없기 때문에 추가함
    #if targetEnvironment(simulator)
    @StateObject var dataController = DataController.preview
    #else
    @StateObject var dataController = DataController.shared // StateObject 로 감싸주면 preview 에서 실행되는 것을 막을 수 있음
    #endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
