//
//  DetailViewController.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/03/24.
//

import UIKit

//MARK: - DetailViewController Class
class DetailViewController: UIViewController {
    
    
    //프로퍼티
    var movieModel: MovieDetail? {
        didSet {
            guard let model = self.movieModel else { return }
            //영화 포스터
            self.prepareMoviePosterURL = model.backdrop_path
            //영화 포스터 이미지 없을 때
            self.prepareMoviePosterSpareURL = model.poster_path
            //영화제목
            self.prepareMovieTitle = model.title
            //영화 평점
            self.prepareMovieRating = String(format: "%.2f", model.vote_average)
            //영화 개봉일
            self.prepareMovieReleaseDate = model.release_date
            //영화 줄거리
            if model.overview == "" {
                self.prepareMovieOverview = "내용을 준비 중입니다."
            } else {
                self.prepareMovieOverview = model.overview
            }
            //찜하기
            self.setHeart(FavoritesMoviesManager.shared.contains(movieID: model.id))
        }
    }
    
    var prepareMoviePosterURL: String?
    var prepareMoviePosterSpareURL: String?
    
    var prepareMovieTitle: String?
    var prepareMovieRating: String?
    var prepareMovieReleaseDate: String?
    var prepareMovieOverview: String?
    
    @IBOutlet var navigationBar: UINavigationItem!
    
    var heartButton: UIBarButtonItem?
    var isHeart: Bool = false
    
    @IBOutlet var moviePoster: UIImageView!
    
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieRating: UILabel!
    @IBOutlet var movieReleaseDate: UILabel!
    @IBOutlet var movieOverview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //영화 포스터
        if self.prepareMoviePosterURL == nil {
            self.moviePoster.contentMode = .scaleAspectFit
            if let urlStr = self.prepareMoviePosterSpareURL {
                self.PosterImageCashe(urlStr)
            }
        } else {
            if let urlStr = self.prepareMoviePosterURL {
                self.PosterImageCashe(urlStr)
            }
        }
        //영화 제목
        self.movieTitle.text = self.prepareMovieTitle
        //영화 평점
        self.movieRating.text = self.prepareMovieRating
        //영화 개봉일
        self.movieReleaseDate.text = self.prepareMovieReleaseDate
        //영화 줄거리
        self.movieOverview.text = self.prepareMovieOverview
        
        //찜하기 버튼
        self.heartButton = UIBarButtonItem(image: nil, style: .plain, target: nil, action: #selector(heartButtonDidTap))
        self.heartButton?.image = self.isHeart ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        self.heartButton?.tintColor = .systemRed
        self.navigationBar.rightBarButtonItem = self.heartButton
    }
    
    //heartButtonDidTap
    @objc func heartButtonDidTap() {
        self.setHeart(!self.isHeart)
        guard let model = self.movieModel else { return }
        if self.isHeart {
            self.addFavoritesListButtonAlert()
            FavoritesMoviesManager.shared.addMovie(model)
        } else {
            self.removeFavoritesListButtonAlert()
            FavoritesMoviesManager.shared.removeMovie(model.id)
        }
    }
    //하트 상태 변경
    private func setHeart(_ heart: Bool) {
        self.isHeart = heart
        if isHeart {
            self.heartButton?.image = UIImage(systemName: "heart.fill")
        } else {
            self.heartButton?.image = UIImage(systemName: "heart")
        }
    }
    
    
}

//MARK: - Method Extension
extension DetailViewController {
    private func PosterImageCashe(_ posterURL: String?) {
        let cacheKey = NSString(string: posterURL ?? "")
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.moviePoster.image = cachedImage
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            let imageBaseURL = "https://image.tmdb.org/t/p/w500"
            guard let path = posterURL,
                  let url = URL(string: (imageBaseURL + path)),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async {
                guard self?.movieTitle == self?.movieTitle else { return }
                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                self?.moviePoster?.image = image
            }
        }
    }
    
    //찜한 영화 목록에 추가
    func addFavoritesListButtonAlert() {
        let alert = UIAlertController(title: "'찜한 영화' 목록에 추가되었습니다.", message: nil, preferredStyle: .alert)
        
        // 버튼 생성
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            
        }
        
        // 알람에 버튼 추가
        alert.addAction(okAction)
        
        // 4. 화면에 표현
        present(alert, animated: true)
    }
    //찜한 영화 목록에서 제거
    func removeFavoritesListButtonAlert() {
        let alert = UIAlertController(title: "'찜한 영화' 목록에서 제거되었습니다.", message: nil, preferredStyle: .alert)
        
        // 버튼 생성
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            
        }
        
        // 알람에 버튼 추가
        alert.addAction(okAction)
        
        // 4. 화면에 표현
        present(alert, animated: true)
    }

}
