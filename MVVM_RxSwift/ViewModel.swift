//
//  ViewModel.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/05/03.
//

import Foundation
import RxSwift

class ViewModel {
    private let disposeBag = DisposeBag()
    private let tvNetwork : TVNetwork
    private let movieNetwork : MovieNetwork
    init() {
        let provider = NetworkProvider(endpoint: "")
        tvNetwork = provider.makeTVNetwork()
        movieNetwork = provider.makeMovieNetwork()
    }
    //input, output 정의
    struct Input {
        let tvTrigger : Observable<Void>
        let moTrigger : Observable<Void>
    }
    struct Output {
        let tvList: Observable<[TV]>
        let moList : Observable<MovieResult>
    }
    func transform(input: Input) -> Output {
        //trigger -> 네트워크 -> Observable<T> -> VC 전달 -> VC에서 구독
        //tvTrigger -> Observable<Void> -> Observable<[TV]>
        let tvList = input.tvTrigger.flatMapLatest { [unowned self] _ -> Observable<[TV]> in
            return self.tvNetwork.getTopRatedList().map { $0.results }
        }
        //Observable 1,2,3 합쳐서 하나의 Observable로 바꾸고 싶다면? Observable.combineLatest
        let movieResult = input.moTrigger.flatMapLatest { [unowned self] _ -> Observable<MovieResult> in
            return Observable.combineLatest(self.movieNetwork.getUpcomingList(), self.movieNetwork.getPopularList(), self.movieNetwork.getNowPlayingList()) { upcoming, popular, nowPlaying -> MovieResult in
                return MovieResult(upcoming: upcoming, popular: popular, nowPlaying: nowPlaying)
            }
        }
        return Output(tvList: tvList, moList: movieResult)
    }
}
