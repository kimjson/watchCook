//
//  Recipe+CoreDataClass.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/08.
//
//

import Foundation
import CoreData

@objc(Recipe)
public class Recipe: NSManagedObject {
    public var stepArray: [Step] {
        let stepSet = steps as? Set<Step> ?? []
        
        return stepSet.sorted {
            $0.order < $1.order
        }
    }
    
    public var lastStep: Step? {
        let stepArray = self.stepArray
        if !stepArray.isEmpty {
            return stepArray[stepArray.count - 1]
        }
        return nil
    }
    
    public var lastStepOrder: Int32 {
        return lastStep?.order ?? 0
    }
    
    public var safeTitle: String {
        return title ?? "이름 없는 레시피"
    }
    
    func isSafeTitleMatches(searchText: String) -> Bool {
        let safeTitleWithoutSpaces = safeTitle.replacingOccurrences(of: " ", with: "")
        let searchTextWithoutSpaces = searchText.replacingOccurrences(of: " ", with: "")
        
        return safeTitleWithoutSpaces.contains(searchTextWithoutSpaces)
    }
    
    public static func randomInstance(context: NSManagedObjectContext? = nil) -> Recipe {
        let titles = ["7분 김치찌개", "홍합 양송이 파스타", "들기름 막국수", "들깨 칼국수", "순두부 들깨탕", "만두 그라탕", "어묵 볶음", "버섯 볶음죽", "계란찜 불닭볶음면"]
        let recipe = context != nil ? Recipe(context: context!) : Recipe()
        recipe.title = titles.randomElement()!
        
        let steps: [Step] = (1...4).map {
            let step = Step.randomInstance(context: context)
            step.order = Int32($0)
            return step
        }
        
        recipe.steps = NSSet(array: steps)
        
        return recipe
    }
}
