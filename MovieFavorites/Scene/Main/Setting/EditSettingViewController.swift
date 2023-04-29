//
//  EditSettingViewController.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/04/20.
//

import Foundation
import UIKit

protocol EditSettingViewControllerProtocol {
    func changeProfileName(name: String)
    func changeProfileImage(imageData: Data, isImage: Bool)
}

class EditSettingViewController: UIViewController {
    
    
    //프로퍼티
    var delegate: EditSettingViewControllerProtocol?
    
    @IBOutlet var editProfileImage: UIImageView!
    @IBOutlet var editProfileName: UITextField!
    
    @IBOutlet var editFinishButton: UIBarButtonItem!
    
    private var isImage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isImage = UserDefaults.standard.bool(forKey: "isImage")
        
        //프로필 이미지
        self.editProfileImage.layer.borderWidth = 2
        self.editProfileImage.layer.borderColor = UIColor.lightGray.cgColor
        self.editProfileImage.layer.cornerRadius = 75
        if UserDefaults.standard.data(forKey: "imageData") == nil {
            self.editProfileImage.image = UIImage(systemName: "person")
            self.editProfileImage.tintColor = .lightGray
        } else {
            self.editProfileImage.image = UIImage(data: UserDefaults.standard.data(forKey: "imageData")!)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.editProfileImageDidTap))
        self.editProfileImage.addGestureRecognizer(tapGesture)
        self.editProfileImage.isUserInteractionEnabled = true
        
        //프로필 닉네임
        self.editProfileName.delegate = self
        self.editProfileName.layer.cornerRadius = 20
        if UserDefaults.standard.string(forKey: "nickName") == nil {
            self.editProfileName.text = "닉 네 임"
        } else {
            self.editProfileName.text = UserDefaults.standard.string(forKey: "nickName")
        }
        self.editProfileName.addTarget(self, action: #selector(self.editProfileNameDidTap), for: .touchUpInside)
    }
    
    //빈 화면 터치했을 때
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //완료 버튼 눌렀을 때
    @IBAction func editFinishButtonDidTap(_ sender: Any) {
        guard let newName = self.editProfileName.text else { return }
        guard let newImageData = self.editProfileImage.image?.jpegData(compressionQuality: 1.0) else { return }
        if newName == "" {
            self.delegate?.changeProfileName(name: "닉 네 임")
            UserDefaults.standard.removeObject(forKey: "nickName")
        } else {
            self.delegate?.changeProfileName(name: newName)
            UserDefaults.standard.set(newName, forKey: "nickName")
        }
        self.delegate?.changeProfileImage(imageData: newImageData, isImage: self.isImage)
        
        if self.isImage {
            UserDefaults.standard.set(newImageData, forKey: "imageData")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editProfileImageDidTap(_ sender: Any) {
        self.editProfileImageAlert()
    }
    //닉네임 텍스트 필드 눌렀을 때
    @objc func editProfileNameDidTap(_ sender: Any) {
        self.editProfileName.becomeFirstResponder()
    }
    
    
}

//MARK: - Method Extension
extension EditSettingViewController {
    
    
    func editProfileImageAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //기본 이미지로 변경 버튼
        let baseAction = UIAlertAction(title: "기본 이미지로 변경", style: .default) { _ in
            self.isImage = false
            UserDefaults.standard.set(self.isImage, forKey: "isImage")
            
            UserDefaults.standard.removeObject(forKey: "imageData")
            self.editProfileImage.image = UIImage(systemName: "person")
            self.editProfileImage.tintColor = .lightGray
        }
        //사진을 촬영하여 프로필 설정 버튼
        let cameraAction = UIAlertAction(title: "사진을 촬영하여 프로필로 설정", style: .default) { _ in
            let camera = UIImagePickerController()
            
            camera.sourceType = .camera
            camera.allowsEditing = true
            camera.cameraDevice = .rear
            camera.cameraCaptureMode = .photo
            camera.delegate = self
            self.present(camera, animated: true)
        }
        //앨범에서 선택하여 프로필 성정 버튼
        let albumAction = UIAlertAction(title: "앨범에서 선택하여 프로필로 설정", style: .default) { _ in
            let album = UIImagePickerController()
            
            album.sourceType = .photoLibrary
            album.delegate = self
            self.present(album, animated: true)
        }
        //취소 버튼
        let cancelAction = UIAlertAction(title: "취소", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        
        alert.addAction(baseAction)
        alert.addAction(cameraAction)
        alert.addAction(albumAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate Extension
extension EditSettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.isImage = true
        UserDefaults.standard.set(self.isImage, forKey: "isImage")
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.editProfileImage.image = image
            
        }
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.editProfileImage.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UITextFieldDelegate Extension
extension EditSettingViewController: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        return true
                    }
                }
        guard textField.text!.count < 8 else { return false }
        
        return true
    }
    
    
}
