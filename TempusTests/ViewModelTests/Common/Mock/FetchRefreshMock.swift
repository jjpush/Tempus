//
//  FetchRefreshMock.swift
//  TempusTests
//
//  Created by 이정민 on 2023/05/03.
//

final class FetchRefreshMock: FetchRefreshDelegate {
    func refresh() {
        #if DEBUG
        print("BlockListVIewModelMock: refresh() called")
        #endif
    }
}
