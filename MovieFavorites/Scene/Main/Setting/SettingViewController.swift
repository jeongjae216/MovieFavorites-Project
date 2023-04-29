//
//  SettingViewController.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/04/20.
//

import Foundation
import UIKit
import MessageUI
import Firebase
import FirebaseDatabase

class SettingViewController: UIViewController {
    
    
    //프로퍼티
    var ref: DatabaseReference!
    
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    private let appName = Bundle.main.infoDictionary?["CFBundleName"] as! String
    
    @IBOutlet var naviItem: UINavigationItem!
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileName: UILabel!
    
    @IBOutlet var appInfoButton: UIButton!
    @IBOutlet var appVersionLabel: UILabel!
    @IBOutlet var contactButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //back 버튼
        self.naviItem.backBarButtonItem = UIBarButtonItem(title: "이전", style: .plain, target: self, action: nil)
        self.naviItem.backBarButtonItem?.tintColor = .white
        
        //프로필 이미지
        self.profileImage.layer.borderWidth = 2
        self.profileImage.layer.borderColor = UIColor.lightGray.cgColor
        self.profileImage.layer.cornerRadius = 50
        if UserDefaults.standard.data(forKey: "imageData") == nil {
            self.profileImage.image = UIImage(systemName: "person")
            self.profileImage.tintColor = .lightGray
        } else {
            self.profileImage.image = UIImage(data: UserDefaults.standard.data(forKey: "imageData")!)
        }
        
        //프로필 닉네임
        if UserDefaults.standard.string(forKey: "nickName") == nil {
            self.profileName.text = "닉 네 임"
        } else {
            self.profileName.text = UserDefaults.standard.string(forKey: "nickName")
        }
        
        //앱 버전
        self.appVersionLabel.text = "v\(self.version)"
    }
    
    //데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? EditSettingViewController {
            viewController.delegate = self
        }
    }
    
    //앱 정보 버튼 눌렀을 때
    @IBAction func appInfoButtonDidTap(_ sender: Any) {
        self.appversionAlert()
    }
    //문의하기 버튼 눌렀을 때
    @IBAction func contactButtonDidTap(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            guard MFMailComposeViewController.canSendMail() else {
                self.showSendMailErrorAlert()
                
                return
            }
            
            let compseVC = MFMailComposeViewController()
            
            compseVC.mailComposeDelegate = self
            
            compseVC.setToRecipients(["develope216@gmail.com"])
            compseVC.setSubject("\(self.appName) 앱/ 문의 및 의견")
            compseVC.setMessageBody("문의 내용을 상세히 작성해주세요.", isHTML: false)
            
            self.present(compseVC, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    
}

//MARK: - EditSettingViewControllerProtocol Extension
extension SettingViewController: EditSettingViewControllerProtocol {
    
    
    //닉네임 변경
    func changeProfileName(name: String) {
        self.profileName.text = name
    }
    //프로필 사진 변경
    func changeProfileImage(imageData: Data, isImage: Bool) {
        if isImage {
            self.profileImage.image = UIImage(data: imageData)
        } else {
            self.profileImage.image = UIImage(systemName: "person")
            self.profileImage.tintColor = .lightGray
        }
    }
    
    
}

//MARK: - Method Extension
extension SettingViewController {
    
    
    //앱 버전 정보 확인
    func appversionAlert() {
        self.ref = Database.database().reference()
        
        self.ref.observe(DataEventType.value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any],
                  let dto = FBDataBase(value: value) else { return }
            
            if Double(self.version)! < dto.appVersion {
                self.nonRecentlyAppVersionAlert()
            } else if Double(self.version) == dto.appVersion {
                self.recentlyAppVersionAlert()
            }
        })
    }
    
    func recentlyAppVersionAlert() {
        let alert = UIAlertController(title: "현재 앱 버전", message: "최신버전 입니다.", preferredStyle: .alert)
        //버튼 생성
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            print("okActionDidTap")
        }
        // 알람에 버튼 추가
        alert.addAction(okAction)
        
        // 4. 화면에 표현
        self.present(alert, animated: true)
    }
    
    func nonRecentlyAppVersionAlert() {
        let alert = UIAlertController(title: "현재 앱 버전", message: "최신버전과 다릅니다. 업데이트를 진행해주세요.", preferredStyle: .alert)
        //버튼 생성
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            print("okActionDidTap")
        }
        // 알람에 버튼 추가
        alert.addAction(okAction)
        
        // 4. 화면에 표현
        self.present(alert, animated: true)
    }
    
    //메일 전송 실패 알림
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        sendMailErrorAlert.addAction(confirmAction)
        
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    
}

//MARK: - MFMailComposeViewControllerDelegate Extension
extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
    
    
}
