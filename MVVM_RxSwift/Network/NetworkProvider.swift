//
//  NetworkProvider.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/04/28.
//

import Foundation
//어떤 네트워크든지 생성할 수 있는 클래스
final class NetworkProvider {
    private let endpoint : String
    init(endpoint: String) {
        self.endpoint = "https://api/themoviedb.org/3"
    }
    func makeTVNetwork() -> TVNetwork {
        let network = Network<TVListModel>(endpoint)
        return TVNetwork(network: network)
    }
    func makeMovieNetwork() -> MovieNetwork {
        let network = Network<MovieListModel>(endpoint)
        return MovieNetwork(network: network)
    }
}
