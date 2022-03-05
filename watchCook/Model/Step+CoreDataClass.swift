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
        let stepTexts = ["냄비에 식용유 1숟, 대파 1컵, 돼지고기 200그람, 고추가루 1숟, 설탕 1/2숟, 간장 2숟을 넣는다.", "약불에서 완전히 익을 때까지 볶는다.", "김치 200g, 김치국물 약간, 양파 1/4, 물 150ml, 다진마늘 1을 넣어 섞는다.", "뚜껑을 덮고 7분간 끓인다.", "뜨고, 방황하였으며, 작고 과실이 사막이다. 있는 이상은 아니한 있는 사막이다. 과실이 밥을 때까지 이것이야말로 이는 이상은 운다. 그러므로 이는 이상은 투명하되 이상을 무엇이 그들의 과실이 인간은 철환하였는가? 커다란 것은 행복스럽고 약동하다. 생명을 용감하고 광야에서 것은 설레는 않는 말이다. 뛰노는 피어나는 얼마나 고행을 불어 오직 끝까지 산야에 사막이다. 인간은 있는 대한 충분히 그들에게 있는 미인을 피고 목숨을 이것이다. 천자만홍이 품으며, 창공에 희망의 살았으며, 튼튼하며, 봄바람이다. 모래뿐일 못하다 날카로우나 영락과 힘차게 아니더면, 자신과 부패를 아니다."]
        
        let stepSeconds: [Int32] = [0, 60, 180, 300, 600]
        
        let step = context != nil ? Step(context: context!) : Step()
        step.text = stepTexts.randomElement()!
        step.seconds = stepSeconds.randomElement()!
        
        return step
    }
    
    public var safeText: String {
        return text ?? ""
    }
}
