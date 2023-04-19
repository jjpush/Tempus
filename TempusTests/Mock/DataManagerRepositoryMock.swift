//
//  DataManagerRepositoryMock.swift
//  TempusTests
//
//  Created by 이정민 on 2023/03/31.
//

import Foundation

final class DataManagerRepositoryMock: DataManagerRepository {
    var timerModel: TimerModel?
    var blockModel: BlockModel?
    var dailyModel: DailyModel?
    
    func create(model: TimerModel) throws {
        timerModel = model
    }
    
    func create(model: BlockModel) throws {
        blockModel = model
    }
    
    func create(model: DailyModel) throws {
        dailyModel = model
    }
    
    func fetchAllTimerModel() throws -> [TimerModel] {
        return [timerModel!]
    }
    
    func fetchAllBlockModel() throws -> [BlockModel] {
        return [blockModel!]
    }
    
    func fetchAllDailyModel() throws -> [DailyModel] {
        return [dailyModel!]
    }
    
    func update(_ model: TimerModel) throws {
        timerModel = model
    }
    
    func update(_ model: BlockModel) throws {
        blockModel = model
    }
    
    func update(_ model: DailyModel) throws {
        dailyModel = model
    }
    
    func delete(_ model: TimerModel) throws {
        timerModel = nil
    }
    
    func delete(_ model: BlockModel) throws {
        blockModel = nil
    }
    
    func delete(_ model: DailyModel) throws {
        dailyModel = nil
    }
    
    
}
