//
//  ViewModel.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/05/03.
//

import Foundation
import RxSwift

class ViewModel {
    private let diseposeBag = DisposeBag()
    //input, output 정의
    struct Input {
        let tvTrigger : Observable<Void>
        let moTrigger : Observable<Void>
    }
    struct Output {
        let tvList: Observable<[TV]>
        let moList : Observable<[MovieResult]>
    }
    func transform(input: Input) -> Output {
        return Output(tvList: Observable<[TV]>.just([]), moList: Observable<[MovieResult]>.just([]))
    }
}
