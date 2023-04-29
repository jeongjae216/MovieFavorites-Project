//
//  CustomCell.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/03/20.
//

import UIKit
import Alamofire

class CustomCell: UITableViewCell {

    
    @IBOutlet var moviePosterImageView: UIImageView!
    
    @IBOutlet var movieTitleLabel: UILabel!
    
    @IBOutlet var movieOverviewLabel: UILabel!
    @IBOutlet var movieRatingLabel: UILabel!
    @IBOutlet var movieDirectorLabel: UILabel!
    @IBOutlet var movieActorLabel: UILabel!
    
    var model: MovieDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.movieTitleLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.model = nil
        self.moviePosterImageView.image = nil
    }
    
    func displayModel(_ model: MovieDetail) {
        self.model = model
        
        //셀 선택효과 없애기
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        //영화 포스터 이미지
        self.displayPosterImage(of: model)
        //영화 제목
        self.movieTitleLabel?.text = model.title
        //영화 줄거리
        if model.overview == "" {
            self.movieOverviewLabel.text = "내용을 준비 중입니다."
        } else {
            self.movieOverviewLabel?.text = model.overview
        }
        self.movieOverviewLabel?.textColor = .lightGray
        self.movieOverviewLabel?.sizeToFit()
        //영화 평점
        let ratingStr = String(format: "%.2f", model.vote_average)
        self.movieRatingLabel?.text = ratingStr
    }
    
    private func displayPosterImage(of model: MovieDetail) {
        let cacheKey = NSString(string: model.poster_path ?? "")
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.moviePosterImageView.image = cachedImage
            return
        }
        
//        print("displayPosterImage.startTime:", Date())
        DispatchQueue.global().async { [weak self] in
            let imageBaseURL = "https://image.tmdb.org/t/p/w200"
            guard let path = model.poster_path,
                  let url = URL(string: (imageBaseURL + path)),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async {
//                print("displayPosterImage.completedTime:", Date())
                guard self?.model?.id == model.id else { return }
                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                self?.moviePosterImageView?.image = image
            }
        }
    }
    
    
}

