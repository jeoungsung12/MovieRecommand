//
//  MovieNetwork.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/04/28.
//

import Foundation
import RxSwift

final class MovieNetwork {
    private let network : Network<MovieListModel>
    init(network: Network<MovieListModel>) {
        self.network = network
    }
    func getNowPlayingList() -> Observable<MovieListModel> {
        return network.getItemList(path: "/movie/now_playing")
    }
    func getPopularList() -> Observable<MovieListModel> {
        return network.getItemList(path: "/movie/popular")
    }
    func getUpcomingList() -> Observable<MovieListModel> {
        return network.getItemList(path: "/movie/upcoming")
    }
}
