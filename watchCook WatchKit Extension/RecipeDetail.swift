//
//  RecipeDetail.swift
//  watchCook WatchKit Extension
//
//  Created by jaeseong on 2022/02/03.
//

import SwiftUI

struct RecipeDetail: View {
    @Environment(\.presentationMode) var presentation
    
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
        if isEnd() {
            // exit to recipe list
        } else {
            index += 1
            if !isEnd() {
                currentStep = recipe.stepArray[index]
            }
        }
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
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Spacer()
                    
                    Text(getText())
                        .navigationTitle(recipe.safeTitle)
                    
                    Spacer()

                    HStack{
                        if !isStart() {
                            Button(getSecondaryButtonText(), action: {
                                prevStep()
                            })
                        }
                        
                        Button(getPrimaryButtonText(), action: {
                            if !isEnd() {
                                nextStep()
                            } else {
                                presentation.wrappedValue.dismiss()
                            }
                        })
                    }
                }
                .frame(minHeight: geometry.size.height)
            }
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: Recipe.randomInstance())
    }
}
