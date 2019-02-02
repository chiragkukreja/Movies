//
//  MoviesViewController.swift
//  Movies
//
//  Created by Chirag Kukreja on 31/01/19.
//  Copyright © 2019 Chirag Kukreja. All rights reserved.
//

import UIKit
final class MoviesViewController: UIViewController {

    private enum CellIdentifiers {
        static let list = "List"
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    var viewModel: MoviesViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MOVIES"
        viewModel = MoviesViewModel(networkProvider: AppProvider.networkManager)
        viewModel.delegate = self
        fetchMovies()
    }
    
    // Function to fetch movies from the server
    private func fetchMovies() {
        collectionView.isHidden = true
        viewModel.getNewMovies()
        indicatorView.startAnimating()
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        MovieFilterCoordinator(self.navigationController).show(from: self, filters: viewModel.getAppliedFilters())
    }
}

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.list, for: indexPath) as! MovieCollectionViewCell
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.movie(at: indexPath.row))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.getNewMovies()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 30
        return CGSize(width: width/2, height: width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isLoadingCell(for: indexPath) else { return }
        let movieId = viewModel.movie(at: indexPath.row).id
        MovieDetailCoordinator(self.navigationController).show(from: self, movieId: movieId)
    }
}
extension MoviesViewController: MoviesViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        indicatorView.stopAnimating()
        collectionView.isHidden = false
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            collectionView.reloadData()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        collectionView.reloadItems(at: indexPathsToReload)
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        let title = "Error".localizedString
        let action = UIAlertAction(title: "OK".localizedString, style: .default)
        self.displayAlert(with: title , message: reason, actions: [action])
    }
}

extension MoviesViewController: FilterViewControllerDelegate {
    func handleButttonAction(with filters: Filters) {
        viewModel.minYear = filters.minYear
        viewModel.maxYear = filters.maxYear
        viewModel.resetCurrentPage()
        collectionView.contentOffset = CGPoint(x: 0, y: 0)
        fetchMovies()
    }
}

private extension MoviesViewController {
    // This functuon will whether the current cell is loaded or not
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    // This will reload the rows with data after getting a new page response
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
