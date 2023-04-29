//
//  FavoritesMoviesManager.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/03/28.
//

import Foundation

final class FavoritesMoviesManager {
    
    
    //싱글톤 패턴
    static let shared = FavoritesMoviesManager()
    private init() {
        self.movies = self.getMovies() ?? []
    }
    
    //프로퍼티
    private(set) var movies: [MovieDetail] = [] {
        didSet {
            self.setMovies(self.movies)
        }
    }
    
}

extension FavoritesMoviesManager {
    
    
    //UserDeafaults 데이터 저장
    private func setMovies(_ movies: [MovieDetail]) {
        guard let encoded = try? JSONEncoder().encode(movies) else { return }
        UserDefaults.standard.set(encoded, forKey: "FavoriteMovies")
    }
    //UserDefaults 데이터 불러오기
    private func getMovies() -> [MovieDetail]? {
        guard let object = UserDefaults.standard.object(forKey: "FavoriteMovies") as? Data,
              let movies = try? JSONDecoder().decode([MovieDetail].self, from: object)
        else { return nil }
        return movies
    }
    
    //찜 목록에 추가
    func addMovie(_ movie: MovieDetail) {
        guard !self.contains(movieID: movie.id) else { return }
        self.movies.append(movie)
    }
    //찜 목록에서 제거
    func removeMovie(_ movieID: Int) {
        guard let index = self.movies.firstIndex(where: { $0.id == movieID }) else { return }
        self.movies.remove(at: index)
    }
    //찜 목록 여부 확인
    func contains(movieID: Int) -> Bool {
        return self.movies.contains { $0.id == movieID }
    }
    
    
}
