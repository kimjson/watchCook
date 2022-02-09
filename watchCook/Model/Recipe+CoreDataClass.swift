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
    
    public static func randomInstance() -> Recipe {
        let titles = ["7분김치찌개", "홍합양송이파스타", "들기름막국수", "들깨칼국수"]
        let recipe = Recipe()
        recipe.title = titles.randomElement()!
        
        let step1 = Step.randomInstance()
        step1.order = 1
        
        let step2 = Step.randomInstance()
        step2.order = 2
        
        let step3 = Step.randomInstance()
        step3.order = 3
        
        recipe.steps = NSSet(array: [step1, step2, step3])
        
        return recipe
    }
}
