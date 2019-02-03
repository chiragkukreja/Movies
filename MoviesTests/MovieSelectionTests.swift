//
//  MovieSelectionTests.swift
//  MoviesTests
//
//  Created by Chirag Kukreja on 03/02/19.
//  Copyright © 2019 Chirag Kukreja. All rights reserved.
//

import XCTest
@testable import Movies


class MovieSelectionTests: XCTestCase {
    var movieViewModel: MovieSelectionViewModel!
    override func setUp() {
        super.setUp()
        movieViewModel = MovieSelectionViewModel(networkProvider: AppProvider.networkManager, movieId: 263856)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // This will fetch data from the local stub and then validate the data
    func testMovieDetails() {
        movieViewModel.getMovieDetails {
            XCTAssertNotNil(self.movieViewModel.movieDetails)
            XCTAssertEqual(self.movieViewModel.movieDetails?.title, "Glass")
            XCTAssertNotNil(self.movieViewModel.movieDetails?.posterPath)
        }
        
    }
}
