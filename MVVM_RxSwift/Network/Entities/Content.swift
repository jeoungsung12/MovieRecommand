//
//  Content.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/07/08.
//

import Foundation
struct Content : Decodable, Hashable {
    let title : String
    let overview : String
    let posterURL : String
    let vote : Double
    let releaseDate : String
    
    init(tv: TV) {
        self.title = tv.title ?? ""
        self.overview = tv.overview ?? ""
        self.posterURL = tv.poster_path ?? ""
        self.vote = tv.vote_average ?? 0.0
        self.releaseDate = tv.release_date ?? ""
    }
    init(movie: Movie) {
        self.title = movie.title
        self.overview = movie.overview
        self.posterURL = movie.posterURL
        self.vote = movie.vote
        self.releaseDate = movie.releaseDate
    }
}
