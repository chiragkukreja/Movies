//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by Chirag Kukreja on 30/01/19.
//  Copyright © 2019 Chirag Kukreja. All rights reserved.
//

import XCTest
@testable import Movies

class MoviesTests: XCTestCase {

    var moviesViewModel: MoviesViewModel!
    override func setUp() {
        moviesViewModel = MoviesViewModel(networkProvider: AppProvider.networkManager)
        moviesViewModel.getNewMovies()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMoviesCount() {
        XCTAssertTrue(moviesViewModel.currentCount > 0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
