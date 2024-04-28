//
//  TVNetwork.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/04/28.
//

import Foundation
import RxSwift

final class TVNetwork {
    private let network : Network<TVListModel>
    init(network: Network<TVListModel>) {
        self.network = network
    }
    func getToRatedList() -> Observable<TVListModel> {
        return network.getItemList(path: "/movie/top_rated")
    }
}
// endpoint = "https://api.themoviedb.org/3\(path)"
