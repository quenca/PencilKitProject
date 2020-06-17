//
//  PagesViewControllerTests.swift
//  PencilKitProjectTests
//
//  Created by gustavo.quenca on 17/06/20.
//  Copyright © 2020 gustavo.quenca. All rights reserved.
//

import XCTest
@testable import PencilKitProject

class PagesViewControllerTests: XCTestCase {
    var sut: PagesViewController!
    var mock: UIPageViewControllerDataSourceMock!
    
    override func setUp() {
        sut = PagesViewController()
        mock = UIPageViewControllerDataSourceMock()
        sut.dataSource = mock
    }
    
    func test_callPagesViewControllerDelegate() {
        XCTAssertEqual(mock.hasCalledViewControllerAfter, true)
    }
}
