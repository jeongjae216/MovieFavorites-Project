//
//  FavoritesMovieViewController.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/03/19.
//

import UIKit
import FirebaseDatabase
import Firebase

//MARK: - FavoritesMovieViewController Class
class FavoritesMovieViewController: UIViewController {

    
    //프로퍼티
    @IBOutlet private var tableView: UITableView!
    private let customCell = UINib(nibName: "CustomCell", bundle: nil)
    
    @IBOutlet var naviItem: UINavigationItem!
    @IBOutlet var movieAddButton: UIBarButtonItem!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var sortConditionsButton: UIButton!
    @IBOutlet var sortOrderButton: UIButton!
    
    private var sortConditions: SortConditions = .base
    private var sortOrder: SortOrder = .base
    private var sortedFavoritesMovies: [MovieDetail] {
        let favoritesMovies = FavoritesMoviesManager.shared.movies
        switch (self.sortConditions, self.sortOrder) {
        //제목순 일반정렬
        case (.title, .normal):
            return favoritesMovies.sorted(by: { movie1, movie2 in
                movie1.title < movie2.title
            })
        //제목순 역순정렬
        case (.title, .reverse):
            return favoritesMovies.sorted { movie1, movie2 in
                movie1.title > movie2.title
            }
        //평점순 일반정렬
        case (.grade, .normal):
            return favoritesMovies.sorted(by: { movie1, movie2 in
                movie1.vote_average > movie2.vote_average
            })
        //평점순 역순정렬
        case (.grade, .reverse):
            return favoritesMovies.sorted { movie1, movie2 in
                movie1.vote_average < movie2.vote_average
            }
        //초기화 상태
        default:
            return favoritesMovies
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //back 버튼
        self.naviItem.backBarButtonItem = UIBarButtonItem(title: "이전", style: .plain, target: self, action: nil)
        self.naviItem.backBarButtonItem?.tintColor = .white
        
        //테이블 뷰
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(customCell, forCellReuseIdentifier: "CustomCell")
        self.tableView.separatorColor = .darkGray
        
        //필터 버튼
        self.sortConditionsButton.layer.borderWidth = 1
        self.sortConditionsButton.layer.borderColor = UIColor.white.cgColor
        self.sortConditionsButton.layer.cornerRadius = 15
        self.sortOrderButton.layer.borderWidth = 1
        self.sortOrderButton.layer.borderColor = UIColor.white.cgColor
        self.sortOrderButton.layer.cornerRadius = 15
    }
    
    //데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // FilterViewController 일 경우
        if let viewController = segue.destination as? FilterViewController {
            viewController.delegate = self
            return
        }
        
        // DetailViewController 일 경우
        if let viewController = segue.destination as? DetailViewController {
            viewController.movieModel = self.tableView.indexPathForSelectedRow.map { self.sortedFavoritesMovies[$0.row] }
            return
        }
    }
    
    //뷰가 나타나기 전
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @IBAction func filterButtonTap(_ sender: Any) {
        print(type(of: self), #function)
    }
    @IBAction func sortConditionsButtonTap(_ sender: Any) {
        print(type(of: self), #function)
    }
    @IBAction func sortOrderButtonTap(_ sender: Any) {
        print(type(of: self), #function)
    }
    
    
}

//MARK: - TableViewDelegate Extension
extension FavoritesMovieViewController: UITableViewDelegate {
    
    
    //셀이 눌렸을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "_ShowDetail", sender: self)
    }
    
    
}

//MARK: - TableViewDataSource Extension
extension FavoritesMovieViewController: UITableViewDataSource {
    
    
    //보여주는 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sortedFavoritesMovies.count == 0 {
            tableView.setEmptyMessage("영화를 추가하여 나만의 영화 리스트를 만들어보세요!")
        } else {
            tableView.restore()
        }
        return self.sortedFavoritesMovies.count
    }
    //셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        if let cell = cell as? CustomCell {
            cell.displayModel(self.sortedFavoritesMovies[indexPath.row])
        }
        return cell
    }
    
    
}

//MARK: - FilterViewControllerDelegate Extension
extension FavoritesMovieViewController: FilterViewControllerDelegate {
    

    //필터 적용하기 버튼 눌렸을 떄
    func changeFilterButtonText(_ conditionsSort: String, _ orderSort: String, textColor: UIColor, backgroundColor: UIColor) {
        self.sortConditionsButton.setTitle(conditionsSort, for: .normal)
        self.sortConditionsButton.setTitleColor(textColor, for: .normal)
        self.sortConditionsButton.backgroundColor = backgroundColor
        
        self.sortOrderButton.setTitle(orderSort, for: .normal)
        self.sortOrderButton.setTitleColor(textColor, for: .normal)
        self.sortOrderButton.backgroundColor = backgroundColor
    }
    
    //초기화 버튼 눌렀을 때
    func sortedInit() {
        self.sortConditions = .base
        self.sortOrder = .base
        self.tableView.reloadData()
    }
    //제목순 일반정렬
    func sortedTitleNormal() {
        self.sortConditions = .title
        self.sortOrder = .normal
        self.tableView.reloadData()
    }
    //제목순 역순정렬
    func sortedTitleReverse() {
        self.sortConditions = .title
        self.sortOrder = .reverse
        self.tableView.reloadData()
    }
    //평점순 일반정렬
    func sortedGradeNormal() {
        self.sortConditions = .grade
        self.sortOrder = .normal
        self.tableView.reloadData()
    }
    //평점순 역순정렬
    func sortedGradeReverse() {
        self.sortConditions = .grade
        self.sortOrder = .reverse
        self.tableView.reloadData()
    }
    
    
}

//MARK: - TableView Method Extension
extension UITableView {
    
    
    //셀이 없을 때 보여줄 메세지
    func setEmptyMessage(_ message: String) {
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = .white
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 22, weight: .semibold)
            label.textColor = .systemGray
            label.sizeToFit()
            return label
        }()
        self.backgroundView = messageLabel;
    }
    //셀이 있을 경우 호출 될 함수
    func restore() {
        self.backgroundView = nil
    }
    
    
}
