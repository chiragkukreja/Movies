//
//  MovieCoordinator.swift
//  Movies
//
//  Created by Chirag Kukreja on 02/02/19.
//  Copyright © 2019 Chirag Kukreja. All rights reserved.
//

import UIKit

protocol BaseCoordinatorProtocol: class {
    var navigationController: UINavigationController? {get set}
    init(_ fromController: UINavigationController?)
}

class BaseCoordinator: BaseCoordinatorProtocol {
    var navigationController: UINavigationController?
    required init(_ fromController: UINavigationController? = nil) {
        self.navigationController = fromController
    }
}


final class MovieFilterCoordinator : BaseCoordinator {
    /*This function will present FilterScreen and It take 2 params: from which controller it will be presented and what are the already applied filters */
    func show(from viewController: MoviesViewController, filters: Filters) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        let viewModel = FilterViewModel(filters: filters)
        vc.viewModel = viewModel
        vc.delegate = viewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.view.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        viewController.present(vc, animated: true, completion: nil)
    }
}
final class MovieDetailCoordinator: BaseCoordinator {
    // This function will naviage to Movie Detail ViewController
    func show(from viewController: UIViewController, movieId: Int) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        let selectionViewModel = MovieSelectionViewModel(networkProvider: AppProvider.networkManager, movieId: movieId)
        vc.viewModel = selectionViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
