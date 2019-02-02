//
//  ViewController.swift
//  Movies
//
//  Created by Chirag Kukreja on 30/01/19.
//  Copyright © 2019 Chirag Kukreja. All rights reserved.
//

import UIKit
import SDWebImage

final class MovieSelectionViewController: UIViewController {

    var viewModel: MovieSelectionViewModel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "MOVIE DETAILS"
        viewModel.delegate = self
        viewModel.getMovieDetails()
        indicatorView.startAnimating()
    }
}
extension MovieSelectionViewController: MovieSelectionViewModelDelegate {
    
    func onFetchCompleted() {
        indicatorView.stopAnimating()
        releaseDate.text = viewModel.releaseDate
        self.overview.text = viewModel.overView
        self.rating.text = viewModel.rating
        self.moviePoster.sd_setImage(with: viewModel.posterPath, completed: nil)
    }
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        indicatorView.stopAnimating()
        let title = "Error".localizedString
        let action = UIAlertAction(title: "OK".localizedString, style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}

