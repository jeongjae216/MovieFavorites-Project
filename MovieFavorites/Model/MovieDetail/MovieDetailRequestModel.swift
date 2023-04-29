//
//  MovieDetailRequestModel.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/03/22.
//

import Foundation

//MARK: - MovieDetailRequestModel Struct
struct MovieDetailRequestModel: Codable {
    let query: String
    let api_key: String
    let language: String
    let page: Int
    let include_adult: Bool
}
