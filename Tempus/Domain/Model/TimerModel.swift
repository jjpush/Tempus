//
//  TimerModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/28.
//

import Foundation

struct TimerModel: Model, Hashable, Codable {
    let id: UUID
    var wasteTime: Double
}
