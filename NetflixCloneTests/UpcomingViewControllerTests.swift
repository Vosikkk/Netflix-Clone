//
//  UpcomingViewControllerTests.swift
//  NetflixCloneTests
//
//  Created by Саша Восколович on 07.01.2024.
//

import XCTest
@testable import Netflix_Clone
final class UpcomingViewControllerTests: XCTestCase {

    
    
    var sut: UpcomingViewController!
    
    override func setUp() {
        super.setUp()
        sut = UpcomingViewController()
    }
    
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_loadUpcomingViewController_shouldNotToBeNil() {
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut)
    }
  

}
