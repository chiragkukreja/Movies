//
//  MovieCoordinator.swift
//  Movies
//
//  Created by Chirag Kukreja on 02/02/19.
//  Copyright © 2019 Chirag Kukreja. All rights reserved.
//

import UIKit
import Moya

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
    func show(viewController: MoviesViewController) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        vc.delegate = viewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        viewController.present(vc, animated: true, completion: nil)
    }
}

final class MovieDetailCoordinator: BaseCoordinator {
    func show( from viewController: UIViewController, movieId: Int) {
        let vc: MovieSelectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieSelectionViewController") as! MovieSelectionViewController
        let provider = MoyaProvider<NetworkRouter>(plugins: [NetworkLoggerPlugin(verbose: true)])
        let selectionViewModel = MovieSelectionViewModel(networkProvider: provider, movieId: movieId)
        vc.viewModel = selectionViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
