//
//  PopularMovieViewController.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/04/18.
//

import UIKit
import FirebaseDatabase
import Firebase


class PopularMovieViewController: UIViewController {
    
    
    //프로퍼티
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String

    var ref: DatabaseReference!
    
    private let movieManager = MovieManager()
    private var popularMovie: [MovieDetail] = []
    
    @IBOutlet var naviItem: UINavigationItem! 
    
    @IBOutlet var testbutton: UIButton!
    
    @IBOutlet private var tableView: UITableView!
    private let customCell = UINib(nibName: "CustomCell", bundle: nil)
    
    private var currentPageNum: Int = 1
    private var totalPageCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //버전 확인 후 Alert 띄우기
        self.ref = Database.database().reference()
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any],
                  let dto = FBDataBase(value: value) else { return }
            
            if dto.isForcedUpdate {
                if Double(self.version)! < dto.appVersion {
                    self.forcedUpdateAlert()
                }
            } else {
                if Double(self.version)! < dto.appVersion {
                    self.selectedUpdateAlert()
                }
            }
            
        })
        
        //back 버튼
        self.naviItem.backBarButtonItem = UIBarButtonItem(title: "이전", style: .plain, target: self, action: nil)
        self.naviItem.backBarButtonItem?.tintColor = .white
        
        //테이블 뷰
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(customCell, forCellReuseIdentifier: "CustomCell")
        self.tableView.separatorColor = .darkGray
        self.loadFirstList()
    }
    @IBAction func crashButtonTapped(_ sender: Any) {
          let numbers = [0]
          let _ = numbers[1]
      }
    
    //데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? DetailViewController {
            viewController.movieModel = self.tableView.indexPathForSelectedRow.map { self.popularMovie[$0.row] }
            return
        }
    }

    
}

//MARK: - TableViewDelegate Extension
extension PopularMovieViewController: UITableViewDelegate {
    
    
    //셀이 눌렸을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail_", sender: self)
    }
    //첫번째 페이지가 전부 로딩 됐을 때
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastCellIndex = self.popularMovie.count - 1
        let isLastCell = indexPath.row == lastCellIndex
        if isLastCell {
            self.loadNextList()
        }
    }
    
        
}

//MARK: - TableViewDataSource Extension
extension PopularMovieViewController: UITableViewDataSource {
    
    
    //보여주는 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.popularMovie.count
    }
    //셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        if let cell = cell as? CustomCell {
            cell.displayModel(self.popularMovie[indexPath.row])
        }
        return cell
    }
    
    
    
}

//MARK: - Method Extension
extension PopularMovieViewController {
    
    
    func selectedUpdateAlert() {
        let alert = UIAlertController(title: "업데이트를 진행해주세요.", message: "현재 버전이 출시 버전보다 낮습니다.", preferredStyle: .alert)
        
        // 버튼 생성
        let updateAction = UIAlertAction(title: "업데이트", style: .default) { _ in
            //앱 스토어로 이동
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id6447456441") {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive) { _ in
            print("취소")
        }
        
        // 알람에 버튼 추가
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        // 4. 화면에 표현
        present(alert, animated: true)
    }
    func forcedUpdateAlert() {
        let alert = UIAlertController(title: "업데이트를 진행해주세요.", message: "현재 버전과 출시 버전의 차이가 많이납니다.", preferredStyle: .alert)
        
        // 버튼 생성
        let updateAction = UIAlertAction(title: "업데이트", style: .default) { _ in
            //앱 스토어로 이동
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id6447456441") {
                UIApplication.shared.open(url)
            }
        }
        
        // 알람에 버튼 추가
        alert.addAction(updateAction)
        
        // 4. 화면에 표현
        present(alert, animated: true)
    }
    
    //첫번째 리스트 로드
    private func loadFirstList() {
        self.currentPageNum = 1
        self.movieManager.popularMovie(page: self.currentPageNum) { [weak self] response in
            guard let response = response else { return }
            self?.totalPageCount = response.total_pages
            self?.popularMovie = response.results
            self?.tableView.reloadData()
        }
    }
    //다음 리스트 로드
    private func loadNextList() {
        guard let totalPageCount = self.totalPageCount,
              self.currentPageNum < totalPageCount
        else { return }
        let pageNum = self.currentPageNum + 1
        self.movieManager.popularMovie(page: pageNum) { [weak self] response in
            guard let response = response else { return }
            self?.totalPageCount = response.total_pages
            self?.currentPageNum = pageNum
            self?.popularMovie.append(contentsOf: response.results)
            self?.tableView.reloadData()
        }
    }
    
    
}
