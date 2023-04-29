//
//  SearchViewController.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/03/20.
//

import UIKit

//MARK: - SearchViewController Class
class SearchViewController:UIViewController {
    
    
    //프로퍼티
    private let movieManager = MovieManager()
    private var moviesDetail: [MovieDetail] = []
    
    private let customCell = UINib(nibName: "CustomCell", bundle: nil)
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var naviItem: UINavigationItem!
    
    @IBOutlet private var tableView: UITableView!
    
    private var currentPageNum: Int = 1
    private var totalPageCount: Int?
    
    private var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //back 버튼
        self.naviItem.backBarButtonItem = UIBarButtonItem(title: "이전", style: .plain, target: self, action: nil)
        self.naviItem.backBarButtonItem?.tintColor = .white
        
        //서치 바
        self.searchBar.delegate = self
        self.searchBar.searchTextField.textColor = .white
        self.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "영화 검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        self.searchBar.searchTextField.leftView?.tintColor = .systemGray
        
        //테이블 뷰
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(customCell, forCellReuseIdentifier: "CustomCell")
        self.tableView.separatorColor = .darkGray
    }
    
    //데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowDetail",
              let destination = segue.destination as? DetailViewController,
              let selectedIndex = self.tableView.indexPathForSelectedRow?.row
        else { return }
        destination.movieModel = self.moviesDetail[selectedIndex]
    }

    
}

//MARK: - SearchBarDelegate Extension
extension SearchViewController: UISearchBarDelegate {
    
    
    //검색 버튼 눌렀을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = self.searchBar.text else { return }
        self.searchText = searchText
        self.searchBar.endEditing(true)
        
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        self.loadFirstList(searchText: self.searchText)
    }
    
    
}

//MARK: - TableViewDelegate Extension
extension SearchViewController: UITableViewDelegate {
    
    
    //셀이 눌렸을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    //첫번째 페이지가 전부 로딩 됐을 때
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastCellIndex = self.moviesDetail.count - 1
        let isLastCell = indexPath.row == lastCellIndex
        if isLastCell {
            self.loadNextList(searchText: self.searchText)
        }
    }
    
        
}

//MARK: - TableViewDataSource Extension
extension SearchViewController: UITableViewDataSource {
    
    
    //보여주는 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.moviesDetail.count
    }
    //셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        if let cell = cell as? CustomCell {
            cell.displayModel(self.moviesDetail[indexPath.row])
        }
        return cell
    }
    
    
    
}

//MARK: - Method Extension
extension SearchViewController {
    
    
    //첫번째 리스트 로드
    private func loadFirstList(searchText: String) {
        self.currentPageNum = 1
        self.movieManager.detailRequest(from: searchText, page: self.currentPageNum) { [weak self] response in
            guard let response = response else { return }
            self?.totalPageCount = response.total_pages
            self?.moviesDetail = response.results
            self?.tableView.reloadData()
        }
    }
    //다음 리스트 로드
    private func loadNextList(searchText: String) {
        guard let totalPageCount = self.totalPageCount,
              self.currentPageNum < totalPageCount
        else { return }
        let pageNum = self.currentPageNum + 1
        self.movieManager.detailRequest(from: searchText, page: self.currentPageNum) { [weak self] response in
            guard let response = response else { return }
            self?.totalPageCount = response.total_pages
            self?.currentPageNum = pageNum
            self?.moviesDetail.append(contentsOf: response.results)
            self?.tableView.reloadData()
        }
    }
    
    
}
