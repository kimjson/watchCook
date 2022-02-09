//
//  RecipeDetail.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/07.
//

import SwiftUI

struct RecipeDetail: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var recipe: Recipe

    var body: some View {
        List(recipe.stepArray) { step in
            HStack {
                Text(step.text ?? "")
                Spacer()
                Button("수정", action: noop)
            }
            
        }
        .navigationTitle(recipe.title ?? "이름 없는 레시피")
        .toolbar {
            Button("단계 추가") {
                let stepTexts = ["냄비에 식용유 1숟, 대파 1컵, 돼지고기 200그람, 고추가루 1숟, 설탕 1/2숟, 간장 2숟을 넣는다.", "약불에서 완전히 익을 때까지 볶는다.", "김치 200그람, 김치국물 약간, 양파 1/4개, 물 150밀리리터, 다진마늘 1숟을 넣어 섞는다.", "뚜껑을 덮고 7분간 끓인다."]
                
                let step = Step(context: moc)
                step.text = stepTexts.randomElement()!
                step.order = recipe.lastStepOrder + 1
                
                recipe.addToSteps(step)
                
                try? moc.save()
            }
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        Text("No previews yet")
//        RecipeDetail()
    }
}
