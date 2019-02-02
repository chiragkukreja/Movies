//
//  NetworkManager.swift
//  Movies
//
//  Created by Chirag Kukreja on 31/01/19.
//  Copyright © 2019 Chirag Kukreja. All rights reserved.
//

import UIKit
import Moya

public typealias NetworkProvider = MoyaProvider

enum NetworkRouter {
    case discover(page: Int, maxYear: String, minYear: String)
    case movieDetails(id: Int)
}
struct Constant {
    static let apiKey = "a31d7d7066379405a7d51c8e838527b9"
    static let imgaelogoPath = "http://image.tmdb.org/t/p/w300/"
}
extension NetworkRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.themoviedb.org/3/") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .movieDetails(let id):
            return "movie/\(id)"
        case .discover:
            return "discover/movie"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .movieDetails:
            return .requestParameters(parameters: ["api_key":  Constant.apiKey], encoding: URLEncoding.queryString)
        case .discover(let page, let maxYear, let minYear):
            return .requestParameters(parameters: ["page":page, "release_date.lte" : maxYear, "release_date.gte": minYear, "api_key": Constant.apiKey], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    // stuff
}
