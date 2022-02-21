//
//  TimeValue.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/21.
//

import Foundation

struct TimeValue {
    let min: Int
    let sec: Int
    
    public var seconds: Int32 {
        return Int32(min * 60 + sec)
    }
    
    init(seconds: Int32) {
        min = Int(seconds / 60)
        sec = Int(seconds % 60)
    }
    
    init(min: Int, sec: Int) {
        self.min = min
        self.sec = sec
    }
    
    public var humanized: String {
        var text = "타이머"
        if sec > 0 {
            text = "\(sec)초 \(text)"
        }
        if min > 0 {
            text = "\(min)분 \(text)"
        }
        return text
    }
}
