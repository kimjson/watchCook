//
//  SwiftUIView.swift
//  watchCook WatchKit Extension
//
//  Created by jaeseong on 2022/02/22.
//

import SwiftUI

struct TimerView: View {
    var seconds: Int32
    
    @EnvironmentObject var alarmController: AlarmController
    @Environment(\.presentationMode) var presentation
    
    @State private var totalSeconds: Int32 = 0
    @State private var remainingSeconds: Int32 = 0
    @State private var startedAt: Date?
    @State private var timer: Timer?
    
    // MARK: 계산되는 속성
    var isStarted: Bool {
        return startedAt != nil
    }
    
    var remainingTimeText: String {
        if !isStarted {
            return TimeValue(seconds: totalSeconds).humanized
        } else if remainingSeconds > 0 {
            return TimeValue(seconds: remainingSeconds).humanized
        } else if remainingSeconds == 0 {
            return "타이머 완료!"
        } else {
            return ""
        }
    }
    
    var leftButtonText: String {
        return "종료"
    }
    
    var rightButtonText: String {
        if remainingSeconds == 0 {
            return "재시작"
        } else if isStarted {
            return "일시정지"
        } else {
            return "재개"
        }
    }
    
    var rightButtonSymbolName: String {
        if remainingSeconds == 0 {
            return "arrow.counterclockwise"
        } else if isStarted {
            return "pause"
        } else {
            return "play.fill"
        }
    }
    
    // MARK: 이벤트 처리 함수
    
    func updateRemainingSeconds() {
        if let startedAt = self.startedAt {
            let elapsedSeconds = Int32(Date().timeIntervalSince(startedAt))
            remainingSeconds = max(totalSeconds - elapsedSeconds, 0)
        }
    }

    func startTimer() {
        totalSeconds = seconds
        resumeTimer()
    }
    
    func pauseTimer() {
        totalSeconds = remainingSeconds
        stopTimer()
    }
    
    func resumeTimer() {
        startedAt = Date()
        updateRemainingSeconds()
        
        alarmController.scheduleAlarm(at: startedAt!.addingTimeInterval(Double(remainingSeconds)))
        
        self.timer = Timer(timeInterval: 1.0, repeats: true) { timer in
            if remainingSeconds == 0 {
                timer.invalidate()
            }

            updateRemainingSeconds()
        }
        
        if let timer = self.timer {
            RunLoop.current.add(timer, forMode: .default)
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
        alarmController.invalidateAlarm()
        startedAt = nil
    }
    
    func navigateBack() {
        presentation.wrappedValue.dismiss()
    }
    
    func handleRightButtonClick() {
        if remainingSeconds == 0 {
            stopTimer()
            startTimer()
        } else if isStarted {
            pauseTimer()
        } else {
            resumeTimer()
        }
    }
    
    func closeTimer() {
        stopTimer()
        navigateBack()
    }
    
    // MARK: 바디
    
    var body: some View {
        VStack {
            Spacer()
            Text(remainingTimeText)
                .font(.title)
            Spacer()
            HStack {
                Button(role: .destructive, action: closeTimer) {
                    Label(leftButtonText, systemImage: "xmark")
                }
                Spacer()
                Button(action: handleRightButtonClick) {
                    Label(rightButtonText, systemImage: rightButtonSymbolName)
                }
            }
            .font(.subheadline.bold())
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    stopTimer()
                    navigateBack()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.secondary)
                })
            }
        }
        .onAppear(perform: startTimer)
        
    }
}

struct TimerSheet_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(seconds: 10)
    }
}
