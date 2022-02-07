//
//  RecipeDetail.swift
//  watchCook WatchKit Extension
//
//  Created by jaeseong on 2022/02/03.
//

import SwiftUI

struct RecipeDetail: View {
    @State private var index: Int = -1
    @State private var text: String = "준비되셨나요"
    @State private var currentStep: Step? = nil

    var recipe: Recipe
    
    func isStart() -> Bool {
        return index == -1
    }
    
    func isEnd() -> Bool {
        return index == recipe.steps.count
    }
    
    func nextStep() {
        index += 1
        currentStep = recipe.steps[index]
    }
    
    func prevStep() {
        index -= 1
        currentStep = isStart() ? nil : recipe.steps[index]
    }
    
    func getText() -> String {
        if (isStart()) {
            return "준비되셨나요?"
        } else if (isEnd()) {
            return "요리 끝!"
        } else {
            return currentStep?.text ?? ""
        }
    }
    
    func getPrimaryButtonText() -> String {
        if (isStart()) {
            return "시작하기"
        } else if (isEnd()) {
            return "맛있게 먹기"
        } else {
            return "다음"
        }
    }
    
    func getSecondaryButtonText() -> String {
        return "이전"
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(getText())
                .navigationTitle(recipe.title)
            Spacer()

            HStack{
                if (!isStart()) {
                    Button(action: {
                        prevStep()
                    }) {
                        Text(getSecondaryButtonText())
                    }
                }
                
                Button(action: {
                    nextStep()
                }) {
                    Text(getPrimaryButtonText())
                }
            }
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: Recipe(
            id: 1,
            title: "7분김치찌개",
            steps: [
                Step(
                    text: "냄비에 식용유 1숟, 대파 1컵, 돼지고기 200그람, 고추가루 1숟, 설탕 1/2숟, 간장 2숟을 넣는다.",
                    seconds: 0
                ),
                Step(
                    text: "약불에서 완전히 익을 때까지 볶는다.",
                    seconds: 0
                ),
                Step(
                    text: "김치 200그람, 김치국물 약간, 양파 1/4개, 물 150밀리리터, 다진마늘 1숟을 넣어 섞는다.",
                    seconds: 0
                ),
                Step(
                    text: "뚜껑을 덮고 7분간 끓인다.",
                    seconds: 420
                ),
            ]
        ))
    }
}
