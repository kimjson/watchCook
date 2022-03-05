//
//  SwiftUIView.swift
//  watchCook WatchKit Extension
//
//  Created by jaeseong on 2022/02/22.
//

import SwiftUI

enum TimerStatus {
    case initializing
    case paused
    case active
    case expired
}

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
    
    var status: TimerStatus {
        if totalSeconds == 0 {
            return .initializing
        } else if startedAt == nil {
            return .paused
        } else if remainingSeconds > 0 {
            return .active
        } else {
            return .expired
        }
    }
    
    var remainingTimeText: String {
        switch status {
        case .initializing:
            return TimeValue(seconds: seconds).humanized
        case .active:
            return TimeValue(seconds: remainingSeconds).humanized
        case .paused:
            return TimeValue(seconds: totalSeconds).humanized
        case .expired:
            return "타이머 완료!"
        }
    }
        
    var rightButtonText: String {
        switch status {
        case .initializing, .active:
            return "일시정지"
        case .paused:
            return "재개"
        case .expired:
            return "재시작"
        }
    }
    
    var rightButtonSymbolName: String {
        switch status {
        case .initializing, .active:
            return "pause"
        case .paused:
            return "play.fill"
        case .expired:
            return "arrow.counterclockwise"
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
        precondition(totalSeconds > 0)
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
    
    func restartTimer() {
        stopTimer()
        startTimer()
    }
    
    func navigateBack() {
        presentation.wrappedValue.dismiss()
    }
    
    func handleRightButtonClick() {
        switch status {
        case .initializing:
            break
        case .active:
            pauseTimer()
        case .paused:
            resumeTimer()
        case .expired:
            restartTimer()
        }
    }
    
    // TODO: 타이머 페이지에서 뒤로 가기 눌러도 타이머가 진행되고, 그동안 다른 단계를 둘러볼 수 있도록 수정해야 함
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
                    Label("종료", systemImage: "xmark")
                }
                Spacer()
                Button(action: handleRightButtonClick) {
                    Label(rightButtonText, systemImage: rightButtonSymbolName)
                }
                .disabled(status == .initializing)
            }
            .font(.subheadline.bold())
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: closeTimer, label: {
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
