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

    var recipe: Recipe
    
    // MARK: 계산되는 속성
    
    var isStart: Bool {
        return index == -1
    }
    
    var isEnd: Bool {
        return index == recipe.stepArray.count
    }
    
    var timerSeconds: Int32 {
        return currentStep?.seconds ?? 0
    }
    
    var timerValue: TimeValue? {
        return timerSeconds > 0 ? TimeValue(seconds: timerSeconds) : nil
    }
    
    var doesTimerExist: Bool {
        return timerValue != nil
    }
    
    var currentStep: Step? {
        return recipe.getStepAt(index: index)
    }
    
    var timerText: String {
        return timerValue?.humanized ?? ""
    }
    
    var text: String {
        if isStart {
            return "준비되셨나요?"
        } else if isEnd {
            return "모든 단계가 끝났습니다.\n맛있게 드세요!"
        } else {
            return currentStep?.text ?? ""
        }
    }
    
    var primaryButtonText: String {
        if isStart {
            return "시작하기"
        } else if isEnd {
            return "끝내기"
        } else {
            return "다음"
        }
    }
    
    var primaryButtonSymbolName: String {
        if isEnd {
            return "xmark"
        } else {
            return "arrow.right"
        }
    }
    
    // MARK: 사용자의 액션 혹은 이벤트 처리
    
    func prevStep() {
        if !isStart {
            index -= 1
        }
    }
    
    func nextStep() {
        if !isEnd {
            index += 1
        } else {
            presentation.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
                VStack(spacing: 2) {
                    Spacer()
                    Text(text)
                        .minimumScaleFactor(0.8)
                    
                    if doesTimerExist {
                        Spacer()
                        NavigationLink(destination: TimerView(seconds: timerSeconds), label: {
                            Label("\(timerText) 타이머", systemImage: "alarm")
                        })
                            .buttonStyle(.borderless)
                            .foregroundColor(.accentColor)
                            .font(.subheadline.bold())
                    }
                    
                    Spacer()

                    HStack{
                        if !isStart {
                            Button(action: prevStep) {
                                Label("이전", systemImage: "arrow.left")
                                    .font(.body.bold())
                            }

                            Spacer()
                        }
                        
                        Button(action: nextStep) {
                            Label(primaryButtonText, systemImage: primaryButtonSymbolName)
                                .font(.body.bold())
                        }
                            .buttonStyle(.borderedProminent)
                            
                    }
                }
                .frame(minHeight: geometry.size.height)
                .navigationTitle(recipe.safeTitle)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: Recipe.randomInstance())
    }
}
