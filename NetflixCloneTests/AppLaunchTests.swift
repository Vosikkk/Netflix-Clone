//
//  AppLaunchTests.swift
//  NetflixCloneTests
//
//  Created by Саша Восколович on 08.01.2024.
//

import XCTest

final class AppLaunchTests: XCTestCase {

    func test_didFinishLaunching_ShouldBeTrue() {
        let sut = TestingAppDelegate()
        let didFinishLaunching = sut.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(didFinishLaunching)
    }

}
