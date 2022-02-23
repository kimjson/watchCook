//
//  AlarmController.swift
//  watchCook WatchKit Extension
//
//  Created by jaeseong on 2022/02/23.
//

import Foundation
import WatchKit

class AlarmController: NSObject, ObservableObject, WKExtendedRuntimeSessionDelegate {
    var session: WKExtendedRuntimeSession?
    
    func scheduleAlarm(at: Date) {
        session = WKExtendedRuntimeSession()
        session?.delegate = self
        
        session?.start(at: at)
    }
    
    // MARK:- Extended Runtime Session Delegate Methods
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Track when your session starts.
        // TODO: 알람 창에서 유저가 앱을 열었을 때 세션 비활성화하기 (이걸 알아서 안 해준다고?)
        session?.notifyUser(hapticType: .notification)
    }

    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Finish and clean up any tasks before the session ends.
    }
        
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        // Track when your session ends.
        // Also handle errors here.
    }
}
