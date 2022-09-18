//
//  Seeds.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/09/09.
//

import XCTest
@testable import DidTodayUIKit

struct Seeds {
    struct Dids {
        static let mock = Did(id: UUID(),
                                 started: Date(),
                                 finished: Date(),
                                 content: "It is mock",
                                 red: 0,
                                 green: 0,
                                 blue: 0,
                                 alpha: 0)
    }
}
