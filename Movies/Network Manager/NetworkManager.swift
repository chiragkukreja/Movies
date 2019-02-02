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

struct AppProvider {
    static let networkManager : MoyaProvider<NetworkRouter> = {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return MoyaProvider<NetworkRouter>(stubClosure: MoyaProvider.immediatelyStub)
        } else {
           return  MoyaProvider<NetworkRouter>(plugins: [NetworkLoggerPlugin(verbose: true)])
        }
    }()
}
enum NetworkRouter {
    case discover(page: Int, maxYear: String, minYear: String)
    case movieDetails(id: Int)
}
struct Constant {
    static let apiKey = "a31d7d7066379405a7d51c8e838527b9"
    static let imgaelogoPath = "http://image.tmdb.org/t/p/w154/"
    static let imagepath = "http://image.tmdb.org/t/p/w500/"
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
    // while testing this will get data from the local json file not from the server
    var sampleData: Data {
        switch self {
        case .movieDetails:
            return StubResponse.fromJSONFile("MovieDetails")
        case .discover:
            return StubResponse.fromJSONFile("MoviesList")
        }
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
}
