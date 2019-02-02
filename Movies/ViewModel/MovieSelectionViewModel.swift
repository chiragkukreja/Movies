//
//  MovieSelectionViewModel.swift
//  Movies
//
//  Created by Chirag Kukreja on 02/02/19.
//  Copyright © 2019 Chirag Kukreja. All rights reserved.
//

import UIKit
protocol MovieSelectionViewModelDelegate: class {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
}

class MovieSelectionViewModel {

    var networkProvider: NetworkProvider<NetworkRouter>!
    weak var delegate: MovieSelectionViewModelDelegate?
    
    var movieId: Int
    var movieDetails: Movie?
    var releaseDate: String? {
        return movieDetails?.releaseDate
    }
    var overView: String? {
        return movieDetails?.overview
    }
    var rating: String {
        return "\(movieDetails?.rating ?? 0)"
    }
//    var genres: String? {
//        return movieDetails?.genres.map({$0.name}).joined(separator: ",")
//    }
//    var languages: String? {
//        return movieDetails?.languages.map({$0.name}).joined(separator: ",")
//    }
    var posterPath: URL? {
        guard let posterPath  = movieDetails?.posterPath else {return nil}
        return  URL(string: Constant.imgaelogoPath+posterPath)
    }
    init(networkProvider: NetworkProvider<NetworkRouter>, movieId: Int) {
        self.networkProvider = networkProvider
        self.movieId = movieId
    }
    
    func getMovieDetails() {
        networkProvider.request(.movieDetails(id: movieId)) { [weak self] result in
            guard let `self` = self else {return}
            
            switch result {
            case let .success(response):
                do {
                    let result = try JSONDecoder().decode(Movie.self, from: response.data)
                    self.movieDetails = result
                    DispatchQueue.main.async {
                        self.delegate?.onFetchCompleted()
                    }
                } catch let err {
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
