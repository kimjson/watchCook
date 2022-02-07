//
//  Recipe.swift
//  watchCook WatchKit Extension
//
//  Created by 김재성 on 2022/01/30.
//

import Foundation

struct Step: Codable {
    let text: String
    let seconds: Int
    
    var hasTimer: Bool {
        get {
            return seconds > 0
        }
    }
}

struct Recipe: Identifiable, Codable {
    let id: Int
    let title: String
    let steps: [Step]
}
