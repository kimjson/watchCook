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
    
    @State private var remainingSeconds: Int32 = 0
    @State private var startedAt: Date?
    @State private var timer: Timer?
    
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
            return "알람 중단 후 닫기"
        } else {
            return "시작"
        }
    }
    
    // MARK: 이벤트 처리 함수
    
    func closeTimerSheet() {
        stopTimer()
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
    
    func handleButtonClick() {
        if !isStarted {
            startTimer()
        } else if remainingSeconds > 0 {
            stopTimer()
        } else if remainingSeconds == 0 {
            closeTimerSheet()
        } else {
            startTimer()
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(remainingTimeText)
                .font(.title)
            Spacer()
            HStack {
                Button(buttonText, action: handleButtonClick)
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
