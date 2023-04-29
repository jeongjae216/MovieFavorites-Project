//
//  MovieManager.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/03/19.
//

import Alamofire
import Foundation

//MARK: - MovieManager Struct
struct MovieManager {
    
    

    //영화 상세 정보 API 요청 함수
    func detailRequest(from keyword: String, page pagenum: Int, completionHandler: @escaping ((MovieDetailResponseModel?) -> Void)) {
            guard let url = URL(string: "https://api.themoviedb.org/3/search/movie") else { return }
            let key = "fcd0a1156e70f8d3966d0af6d2ceddd6"
            let korean = "ko-Kr"
            
            let parameters = MovieDetailRequestModel(query: keyword, api_key: key, language: korean, page: pagenum, include_adult: false)

            AF
                .request(url, method: .get, parameters: parameters)
                .responseDecodable(of: MovieDetailResponseModel.self) { response in
                    switch response.result {
                    case .success(let result):
                        completionHandler(result)
                    case .failure(let error):
                        print(error.localizedDescription)
                        completionHandler(nil)
                    }
                }
                .resume()
        }
    //인기 영화 정보 API 요청 함수
    func popularMovie(page pagenum: Int, completionHandler: @escaping ((MovieDetailResponseModel?) -> Void)) {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular") else { return }
            let key = "fcd0a1156e70f8d3966d0af6d2ceddd6"
            let korean = "ko-Kr"
            
            let parameters = PopularMovieRequestModel(api_key: key, language: korean, page: pagenum)

        AF
            .request(url, method: .get, parameters: parameters)
            .responseDecodable(of: MovieDetailResponseModel.self) { response in
                switch response.result {
                case .success(let result):
                    completionHandler(result)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(nil)
                }
            }
            .resume()
        }

    
}

