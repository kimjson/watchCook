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
    @State private var timerStartedAt: Date? = nil
    @State private var timerRemaining: Int32 = 0
    @State private var isTimerSheetOpen: Bool = false

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
            return "수고하셨어요. 맛있게 드세요!"
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
    
    // MARK: 사용자의 액션 혹은 이벤트 처리
    
    func openTimerSheet() {
        isTimerSheetOpen = true
    }
    
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
            ScrollView {
                VStack {
                    Spacer()
                    
                    Text(text)
                        .navigationTitle(recipe.safeTitle)
                    
                    Spacer()
                    
                    // 남은 시간이 아니라 타이머 자체가 단계에 존재하는지 여부로 렌더해야 할 거 같다.
                    if doesTimerExist {
                        Button(action: openTimerSheet, label: {
                            HStack {
                                // 타이머를 여는 동시에 시작하도록 하는 것도 방법이다.
                                Text("\(timerText) 타이머 열기")
                                Image(systemName: "chevron.right")
                            }
                            
                        })
                            .buttonStyle(.plain)

                        Spacer()
                    }

                    HStack{
                        if !isStart {
                            Button("이전", action: prevStep)
                        }
                        
                        Button(primaryButtonText, action: nextStep)
                            .buttonStyle(.borderedProminent)
                    }
                }
                .frame(minHeight: geometry.size.height)
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isTimerSheetOpen) {
                TimerSheet(isOpen: $isTimerSheetOpen, seconds: timerSeconds)
            }
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: Recipe.randomInstance())
    }
}
