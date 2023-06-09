//
//  Time.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/04.
//

import Foundation

struct Time {
    private(set) var hour: Int
    private(set) var minute: Int
    private(set) var second: Double
    
    var totalSecond: Double {
        return Double(hour * 3600) + Double(minute * 60) + second
    }
    
    init(second: Double) {
        self.hour = Int(second / 3600)
        self.minute = Int((second.truncatingRemainder(dividingBy: 3600)) / 60)
        self.second = second.truncatingRemainder(dividingBy: 60)
    }
    
    mutating func flow(second: Double) {
        self.second -= second
        
        if self.second < 0 {
            self.minute -= 1
            self.second += 60
        }
        
        if self.minute < 0 {
            self.hour -= 1
            self.minute += 60
        }
    }
}
