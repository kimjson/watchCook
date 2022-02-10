//
//  Step+CoreDataClass.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/08.
//
//

import Foundation
import CoreData

@objc(Step)
public class Step: NSManagedObject {
    public static func randomInstance(context: NSManagedObjectContext? = nil) -> Step {
        let stepTexts = ["냄비에 식용유 1숟, 대파 1컵, 돼지고기 200그람, 고추가루 1숟, 설탕 1/2숟, 간장 2숟을 넣는다.", "약불에서 완전히 익을 때까지 볶는다.", "김치 200그람, 김치국물 약간, 양파 1/4개, 물 150밀리리터, 다진마늘 1숟을 넣어 섞는다.", "뚜껑을 덮고 7분간 끓인다."]
        
        let step = context != nil ? Step(context: context!) : Step()
        step.text = stepTexts.randomElement()!
        
        return step
    }
}
