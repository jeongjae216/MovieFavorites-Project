//
//  FilterViewController.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/03/30.
//

import Foundation
import UIKit

//
protocol FilterViewControllerDelegate {
    func changeFilterButtonText(_ conditionsSort: String, _ orderSort: String, textColor: UIColor, backgroundColor: UIColor)
    func sortedInit()
    func sortedTitleNormal()
    func sortedTitleReverse()
    func sortedGradeNormal()
    func sortedGradeReverse()
}

//MARK: - FilterViewController Class
class FilterViewController: UIViewController {
    
    
    //프로퍼티
    var delegate: FilterViewControllerDelegate?
    
    @IBOutlet var initButton: UIButton!
    @IBOutlet var dismissButton: UIButton!
    
    @IBOutlet var titleSortButton: UIButton!
    @IBOutlet var gradeSortButton: UIButton!
    @IBOutlet var normalSortButton: UIButton!
    @IBOutlet var reverseSortButton: UIButton!
    
    var isTitleSort: Bool = true
    var isGradeSort: Bool = false
    var isNormalSort: Bool = true
    var isReverseSort: Bool = false
    
    var storedConditionsButtonBool: Bool = true
    var storedOrderButtonBool: Bool = true
    
    @IBOutlet var filterApplyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.label.withAlphaComponent(0.5)
        
        //닫기 버튼
        self.dismissButton.layer.cornerRadius = 10
        self.dismissButton.sizeToFit()
        
        //제목순 버튼
        self.titleSortButton.layer.cornerRadius = 15
        self.titleSortButton.layer.borderWidth = 1
        self.titleSortButton.layer.borderColor = UIColor.systemGray.cgColor
        
        //평점순 버튼
        self.gradeSortButton.layer.cornerRadius = 15
        self.gradeSortButton.layer.borderWidth = 1
        self.gradeSortButton.layer.borderColor = UIColor.systemGray.cgColor
        
        //일반정렬 버튼
        self.normalSortButton.layer.cornerRadius = 15
        self.normalSortButton.layer.borderWidth = 1
        self.normalSortButton.layer.borderColor = UIColor.systemGray.cgColor
        
        //역순정렬 버튼
        self.reverseSortButton.layer.cornerRadius = 15
        self.reverseSortButton.layer.borderWidth = 1
        self.reverseSortButton.layer.borderColor = UIColor.systemGray.cgColor
        
        //적용하기 버튼
        self.filterApplyButton.layer.cornerRadius = 5
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isButton(self.titleSortButton, UserDefaults.standard.bool(forKey: "Conditions"))
        self.isButton(self.normalSortButton, UserDefaults.standard.bool(forKey: "Order"))
    }
    
    //배경 뷰 눌렀을 때
    @objc func backViewDidTap() {
        self.dismiss(animated: true)
    }
    
    //초기화 버튼 눌렀을 때
    @IBAction func initButtonDidTap(_ sender: Any) {
        self._initButton()
        
        self.delegate?.changeFilterButtonText("정렬 조건", "정렬 순서", textColor: .white, backgroundColor: .label)
        self.delegate?.sortedInit()
        
        self.dismiss(animated: true)
    }
    //닫기 버튼 눌렀을 때
    @IBAction func dismissButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //정렬조건 버튼 눌렀을 때
    @IBAction func sortConditionsButtonDidTap(_ sender: UIButton) {
        if sender == self.titleSortButton {
            self.isButton(self.titleSortButton, true)
        } else {
            self.isButton(self.titleSortButton, false)
        }
    }
    //정렬순서 버튼 눌렀을 때
    @IBAction func sortOrderButtonDidTap(_ sender: UIButton) {
        if sender == self.normalSortButton {
            self.isButton(self.normalSortButton, true)
        } else {
            self.isButton(self.normalSortButton, false)
        }
    }
    
    //필터 적용하기 버튼
    @IBAction func filterApplyButtonDidTap(_ sender: Any) {
        //필터 옵션 적용 코드 구현하기
        if self.isTitleSort {
            if self.isNormalSort {
                //제목순 && 일반정렬
                UserDefaults.standard.set(self.isTitleSort, forKey: "Conditions")
                UserDefaults.standard.set(self.isNormalSort, forKey: "Order")
                self.delegate?.changeFilterButtonText("제목순", "일반정렬", textColor: .label, backgroundColor: .white)
                self.delegate?.sortedTitleNormal()
            } else {
                //제목순 && 역순정렬
                UserDefaults.standard.set(self.isTitleSort, forKey: "Conditions")
                UserDefaults.standard.set(self.isNormalSort, forKey: "Order")
                self.delegate?.changeFilterButtonText("제목순", "역순정렬", textColor: .label, backgroundColor: .white)
                self.delegate?.sortedTitleReverse()
            }
        } else {
            if self.isNormalSort {
                //평점순 && 일반정렬
                UserDefaults.standard.set(self.isTitleSort, forKey: "Conditions")
                UserDefaults.standard.set(self.isNormalSort, forKey: "Order")
                self.delegate?.changeFilterButtonText("평점순", "일반정렬", textColor: .label, backgroundColor: .white)
                self.delegate?.sortedGradeNormal()
            } else {
                //평점순 && 역순정렬
                UserDefaults.standard.set(self.isTitleSort, forKey: "Conditions")
                UserDefaults.standard.set(self.isNormalSort, forKey: "Order")
                self.delegate?.changeFilterButtonText("평점순", "역순정렬", textColor: .label, backgroundColor: .white)
                self.delegate?.sortedGradeReverse()
            }
        }
        
        self.dismiss(animated: true)
    }
    
    
}

//MARK: - Method Extension
extension FilterViewController {
    
    
    //버튼 텍스트 설정
    func buttonSetting(_ button: UIButton ,_ buttonTitle: String, _ buttonColor: UIColor) {
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(buttonColor, for: .normal)
    }
    //버튼 배경색 설정
    func changeSortConditionsButtonBackgroundColor(name: String) {
        self.titleSortButton.backgroundColor = name == "title" ? .white : UIColor(named: "customColor")
        self.gradeSortButton.backgroundColor = name == "grade" ? .white : UIColor(named: "customColor")
    }
    func changeSortOrderButtonBackgroundColor(name: String) {
        self.normalSortButton.backgroundColor = name == "normal" ? .white : UIColor(named: "customColor")
        self.reverseSortButton.backgroundColor = name == "reverse" ? .white : UIColor(named: "customColor")
    }
    //버튼 설정
    func isButton(_ button: UIButton, _ bool: Bool) {
        if self.titleSortButton == button {
            self.isTitleSort = bool
            self.isGradeSort = !bool
            if self.isTitleSort {
                self.buttonSetting(self.titleSortButton, "제목순", .label)
                self.buttonSetting(self.gradeSortButton, "평점순", .white)
                self.changeSortConditionsButtonBackgroundColor(name: "title")
            } else {
                self.buttonSetting(self.titleSortButton, "제목순", .white)
                self.buttonSetting(self.gradeSortButton, "평점순", .label)
                self.changeSortConditionsButtonBackgroundColor(name: "grade")
            }
        } else if self.normalSortButton == button {
            self.isNormalSort = bool
            self.isReverseSort = !bool
            if self.isNormalSort {
                self.buttonSetting(self.normalSortButton, "일반정렬", .label)
                self.buttonSetting(self.reverseSortButton, "역순정렬", .white)
                self.changeSortOrderButtonBackgroundColor(name: "normal")
            } else {
                self.buttonSetting(self.normalSortButton, "일반정렬", .white)
                self.buttonSetting(self.reverseSortButton, "역순정렬", .label)
                self.changeSortOrderButtonBackgroundColor(name: "reverse")
            }
        }
    }

    //초기화 버튼
    func _initButton() {
        UserDefaults.standard.set(true, forKey: "Conditions")
        UserDefaults.standard.set(true, forKey: "Order")
    }
    
    
}
