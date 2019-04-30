//
//  AddAlbumVC.swift
//  EachOther
//
//  Created by daeun on 30/04/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddAlbumVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var albumImageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var addAlbumViewModel: AddAlbumViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAlbumViewModel = AddAlbumViewModel()
        let completeButton = UIBarButtonItem(title: "완료", style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = completeButton
        
        completeButton.rx.tap
            .bind(to: addAlbumViewModel.clickComplete)
            .disposed(by: disposeBag)
        
        datePicker.rx.date
            .bind(to: addAlbumViewModel.selectDate)
            .disposed(by: disposeBag)
        
        titleTextField.rx.text.orEmpty
            .bind(to: addAlbumViewModel.title)
            .disposed(by: disposeBag)
        
        placeTextField.rx.text.orEmpty
            .bind(to: addAlbumViewModel.place)
            .disposed(by: disposeBag)
    }
    
    @IBAction func selectImge(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            albumImageView.image = image
            
            let uploadData = albumImageView.image?.pngData() ?? Data()
            self.addAlbumViewModel.image.accept(uploadData)
        } else {
            print("Error")
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
