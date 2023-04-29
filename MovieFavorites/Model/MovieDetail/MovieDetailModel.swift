//
//  MovieDetailModel.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/03/22.
//

import Foundation

//MARK: - MovieDetailResponseModel Struct
struct MovieDetailResponseModel: Codable {
    var results: [MovieDetail] = []
    var total_pages: Int
}

//MARK: - MovieDetail Struct
struct MovieDetail: Codable {
    let title: String
    let release_date: String
    let overview: String
    let poster_path: String?
    let vote_average: Double
    let backdrop_path: String?
    let id: Int
}
