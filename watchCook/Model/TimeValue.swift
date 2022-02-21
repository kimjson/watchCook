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
        if min > 0 && sec > 0 {
            return "\(min)분 \(sec)초"
        } else if min > 0 {
            return "\(min)분"
        } else if sec > 0 {
            return "\(sec)초"
        }
        return ""
    }
}
