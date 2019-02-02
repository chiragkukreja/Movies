//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Chirag Kukreja on 31/01/19.
//  Copyright © 2019 Chirag Kukreja. All rights reserved.
//

import UIKit

protocol MoviesViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String) 
}
class MoviesViewModel {

    var networkProvider: NetworkProvider<NetworkRouter>!
    weak var delegate: MoviesViewModelDelegate?

    private var movies = [Movie]()
    private var isFetchInProgress = false
    private var totalItems = 0
    private var currentPage = 1
    var minYear = ""
    var maxYear = ""
    
    struct Constant {
        static let failureMessage = "No results Found"
    }
    // This count represents total count  of the movie which we have to load from the server
    var totalCount: Int {
        return totalItems
    }
    
    // this count represts number of movie we have fetched
    var currentCount: Int {
        return movies.count
    }
    
    func movie(at index: Int) -> Movie {
        return movies[index]
    }
    
    init(networkProvider: NetworkProvider<NetworkRouter>) {
        self.networkProvider = networkProvider
    }
    
    // This will reset the all the counts after applying filters
    func resetCurrentPage() {
        currentPage = 1
        movies = [Movie]()
        totalItems = 0
    }
    // This function will fetch movies from the server
    func getNewMovies(){
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        networkProvider.request(.discover(page: currentPage, maxYear: self.maxYear, minYear:self.minYear)) { [weak self] result in
            guard let `self` = self else {return}
            self.isFetchInProgress = false
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    do {
                        let results = try JSONDecoder().decode(MovieResults.self, from: response.data)
                        self.movies.append(contentsOf: results.movies)
                        if self.currentPage == 1 {
                            self.totalItems = results.numberOfResults
                        }
                        if self.movies.isEmpty {
                            self.delegate?.onFetchFailed(with: Constant.failureMessage)
                        }
                        else if results.page > 1 {
                            let indexPathsToReload = self.calculateIndexPathsToReload(from: results.movies)
                            self.delegate?.onFetchCompleted(with: indexPathsToReload)
                        } else {
                            self.delegate?.onFetchCompleted(with: .none)
                        }
                        self.currentPage += 1
                        
                    } catch let err {
                        print(err)
                    }
                case let .failure(_):
                    self.delegate?.onFetchFailed(with: Constant.failureMessage)
                }
            }
        }
            
    }
    // This will give indexpath path of the cells which has to be release after getting new page response
    private func calculateIndexPathsToReload(from newResults: [Movie]) -> [IndexPath] {
        let startIndex = movies.count - newResults.count
        let endIndex = startIndex + newResults.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
