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
        return index == recipe.stepArray.count
    }
    
    func nextStep() {
        index += 1
        currentStep = recipe.stepArray[index]
    }
    
    func prevStep() {
        index -= 1
        currentStep = isStart() ? nil : recipe.stepArray[index]
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
                .navigationTitle(recipe.safeTitle)
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
        RecipeDetail(recipe: Recipe.randomInstance())
    }
}
