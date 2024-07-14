//
//  Network.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/04/28.
//

import Foundation
import RxSwift
import RxAlamofire

class Network<T:Decodable> {
    
    private let endpoint : String
    private let queue : ConcurrentDispatchQueueScheduler
    init(_ endpoint: String) {
        self.endpoint = endpoint
        self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    func getItemList(path: String) -> Observable<T> {
        let fullPath = "\(endpoint)\(path)?&language=ko"
        return RxAlamofire.data(.get, fullPath, headers: ["Authorization":"\(APIKEY)"])
            .observe(on: queue)
            .debug()
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
}
