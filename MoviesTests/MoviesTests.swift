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
        super.setUp()
        moviesViewModel = MoviesViewModel(networkProvider: AppProvider.networkManager)
    }

    override func tearDown() {
       super.tearDown()
    }

    // This will fetch data from the local stub and then validate the data
    func testMoviesData() {
        moviesViewModel.getNewMovies {
            XCTAssertTrue(self.moviesViewModel.currentCount > 0)
            XCTAssertTrue(self.moviesViewModel.totalCount > 0)
            XCTAssertNotNil(self.moviesViewModel.movie(at: 1))
        }
    }
}
