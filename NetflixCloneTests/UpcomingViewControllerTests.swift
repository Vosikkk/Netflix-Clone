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
    
    
    func test_loadUpcomingViewController_shouldNotBeNil() {
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut)
    }
    
    func test_titleOfViewController_titleShouldBeUpcoming() {
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.title, "Upcoming")
    }
    
    
    func test_tableViewAppearOnTheViewController_tableViewShouldNotBeNil() {
        sut.viewDidLoad()
        XCTAssertNotNil(sut.upcomingTable)
    }
    
    func test_viewDidLayuotSubviews_tableFrameShouldBeAsViewFrameSize() {
        sut.loadViewIfNeeded()
        sut.viewDidLayoutSubviews()
        XCTAssertEqual(sut.upcomingTable.frame.size, sut.view.bounds.size)
    }
    
 
    
}




