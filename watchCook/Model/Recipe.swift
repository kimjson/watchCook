//
//  Recipe.swift
//  watchCook WatchKit Extension
//
//  Created by 김재성 on 2022/01/30.
//

import Foundation

struct Step: Identifiable, Codable {
    let id: Int
    let text: String
    let seconds: Int
    
    var hasTimer: Bool {
        get {
            return seconds > 0
        }
    }
}

struct Recipe: Identifiable, Codable {
    var id: Int
    var nextStepId: Int
    var title: String
    var steps: [Step]
}

extension Recipe {
    init() {
        id = Int(Date().timeIntervalSince1970)
        title = "이름없는 레시피"
        steps = []
        nextStepId = 1
    }
    
    mutating func rename(newTitle: String) {
        title = newTitle
    }
    
    mutating func addStep(text: String, seconds: Int = 0) {
        steps += [Step(id: nextStepId, text: text, seconds: seconds)]
        nextStepId += 1
    }
    
    mutating func updateStep(id: Int, text: String?, seconds: Int?) {
        steps = steps.map {
            if $0.id == id {
                return Step(id: $0.id, text: text ?? $0.text, seconds: seconds ?? $0.seconds)
            } else {
                return $0
            }
        }
    }
}
