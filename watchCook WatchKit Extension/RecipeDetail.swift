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
    @State private var currentStep: Step? = nil
    @State private var timerStartedAt: Date? = nil
    @State private var timerRemaining: Int32 = 0

    var recipe: Recipe
    
    // MARK: 계산되는 속성
    
    var timerText: String {
        return TimeValue(seconds: timerRemaining).humanized
    }
    
    var text: String {
        if (isStart()) {
            return "준비되셨나요?"
        } else if (isEnd()) {
            return "수고하셨어요. 맛있게 드세요!"
        } else {
            return currentStep?.text ?? ""
        }
    }
    
    var primaryButtonText: String {
        if isStart() {
            return "시작하기"
        } else if isEnd() {
            return "끝내기"
        } else {
            return "다음"
        }
    }
    
    // MARK: 계산되는 속성으로 "아직" 변환하지 못한 게터 함수
    
    func isStart() -> Bool {
        return index == -1
    }
    
    func isEnd() -> Bool {
        return index == recipe.stepArray.count
    }
    
    // MARK: 사용자의 액션 혹은 이벤트 처리
    
    func updateTimerRemaining() {
        if let startedAt = timerStartedAt {
            let elapsedSeconds = Int32(Date().timeIntervalSince(startedAt))
            timerRemaining = max((currentStep?.seconds ?? 0) - elapsedSeconds, 0)
        } else {
            timerRemaining = currentStep?.seconds ?? 0
        }
    }
    
    func nextStep() {
        if !isEnd() {
            index += 1
            if isEnd() {
                currentStep = nil
            } else {
                currentStep = recipe.stepArray[index]
                updateTimerRemaining()
            }
        }
    }
    
    func prevStep() {
        if !isStart() {
            index -= 1
            if isStart() {
                currentStep = nil
            } else {
                currentStep = recipe.stepArray[index]
                updateTimerRemaining()
            }
        }
    }
    
    func startTimer() {
        if timerStartedAt == nil {
            timerStartedAt = Date()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if timerRemaining == 0 {
                    timerStartedAt = nil
                    timer.invalidate()
                }
                
                updateTimerRemaining()
            }
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
                    if timerRemaining > 0 {
                        Button(action: startTimer, label: {
                            HStack {
                                Text(timerText)
                                Image(systemName: "chevron.right")
                            }
                            
                        })
                            .buttonStyle(.plain)
                        Spacer()
                    }

                    HStack{
                        if !isStart() {
                            Button("이전", action: prevStep)
                        }
                        
                        Button(primaryButtonText, action: {
                            if !isEnd() {
                                nextStep()
                            } else {
                                presentation.wrappedValue.dismiss()
                            }
                        })
                            .buttonStyle(.borderedProminent)
                    }
                }
                .frame(minHeight: geometry.size.height)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: Recipe.randomInstance())
    }
}
