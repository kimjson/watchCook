//
//  watchCookApp.swift
//  watchCook
//
//  Created by 김재성 on 2022/01/30.
//

import SwiftUI

@main
struct watchCookApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
