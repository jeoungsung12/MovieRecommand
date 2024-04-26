//
//  ViewController.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/04/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

//MARK: - 섹션과 아이템 정의
struct Section : Hashable {
    let id : String
}
enum Item : Hashable {
    case banner(HomeItem)
    case normalCarousel(HomeItem)
    case listCarousel(HomeItem)
}
struct HomeItem: Hashable {
    let title : String
    let subTitle : String?
    let imageUrl : String
}
