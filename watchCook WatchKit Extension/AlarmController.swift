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
    
    func invalidateAlarm() {
        session?.invalidate()
        session = nil
    }
    
    // MARK: Extended Runtime Session Delegate Methods
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
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
