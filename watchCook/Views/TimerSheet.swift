//
//  SwiftUIView.swift
//  watchCook WatchKit Extension
//
//  Created by jaeseong on 2022/02/22.
//

import SwiftUI

struct TimerSheet: View {
    var isOpen: Binding<Bool>
    var seconds: Int32
    
    @State private var remainingSeconds: Int32 = 0
    @State private var startedAt: Date?
    
    // MARK: 계산되는 속성
    var isStarted: Bool {
        return startedAt != nil
    }
    
    var remainingTimeText: String {
        if !isStarted {
            return TimeValue(seconds: seconds).humanized
        } else if remainingSeconds > 0 {
            return TimeValue(seconds: remainingSeconds).humanized
        } else if remainingSeconds == 0 {
            return "타이머 완료!"
        } else {
            return ""
        }
    }
    
    var buttonText: String {
        if !isStarted {
            return "시작"
        } else if remainingSeconds > 0 {
            return "정지"
        } else if remainingSeconds == 0 {
            return "다시 시작"
        } else {
            return "시작"
        }
    }
    
    // MARK: 이벤트 처리 함수
    
    func closeTimerSheet() {
        isOpen.wrappedValue = false
    }
    
    func updateRemainingSeconds() {
        if let startedAt = self.startedAt {
            let elapsedSeconds = Int32(Date().timeIntervalSince(startedAt))
            remainingSeconds = max(seconds - elapsedSeconds, 0)
        }
    }

    func startTimer() {
        startedAt = Date()
        updateRemainingSeconds()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if remainingSeconds == 0 {
                timer.invalidate()
            }

            updateRemainingSeconds()
        }
    }
    
    func stopTimer(timer: Timer) {
        timer.invalidate()
        startedAt = nil
    }
    
    func handleButtonClick() {
        if !isStarted {
            startTimer()
        } else if remainingSeconds > 0 {
            // TODO: 타이머 상태 선언 후 적절한 초기값 설정, .scheduledTimer 대신 생성만 하는 메서드 사용 후 타이머 시작은 추후에
//            stopTimer()
        } else {
            startTimer()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text(remainingTimeText)
                    .font(.title)
                Spacer()
                HStack {
                    Button(buttonText, action: handleButtonClick)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("타이머 닫기", action: closeTimerSheet)
                }
            }
        }
        .onAppear(perform: startTimer)
    }
}

struct TimerSheet_Previews: PreviewProvider {
    static var previews: some View {
        TimerSheet(isOpen: .constant(true), seconds: 10)
    }
}
