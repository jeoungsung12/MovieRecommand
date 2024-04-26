//
//  Item.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/04/26.
//

import Foundation

struct Section : Hashable {
    let id : String
}
enum Item : Hashable {
    case banner(HomeItem)
    case normalCarousel(HomeItem)
    case listCarousel(HomeItem)
}
struct HomeItem : Hashable {
    let title : String
    let subTitle : String?
    let imageUrl : String
}
