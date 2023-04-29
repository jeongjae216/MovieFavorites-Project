//
//  PopularMovieRequestModel.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/04/18.
//

import Foundation

//MARK: - PopularMovieRequestModel Struct
struct PopularMovieRequestModel: Codable {
    let api_key: String
    let language: String
    let page: Int
}
