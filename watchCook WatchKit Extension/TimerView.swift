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
        return "종료"
    }
    
    var secondaryButtonText: String {
        if remainingSeconds == 0 {
            return "재시작"
        } else {
            return "일시정지"
        }
    }
    
    // MARK: 이벤트 처리 함수
    
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
    
    func navigateBack() {
        presentation.wrappedValue.dismiss()
    }
    
    func handleButtonClick() {
        if !isStarted {
            startTimer()
        } else if remainingSeconds > 0 {
            stopTimer()
        } else if remainingSeconds == 0 {
            stopTimer()
            navigateBack()
        } else {
            startTimer()
        }
    }
    
    func closeTimer() {
        stopTimer()
        navigateBack()
    }
    
    func pauseTimer() {
        stopTimer()
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
                    Label(buttonText, systemImage: "xmark")
                }
                Spacer()
                Button(action: pauseTimer) {
                    Label(secondaryButtonText, systemImage: "pause")
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
