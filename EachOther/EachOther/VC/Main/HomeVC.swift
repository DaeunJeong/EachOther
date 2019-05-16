//
//  HomeVC.swift
//  EachOther
//
//  Created by daeun on 08/04/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseStorage

class HomeVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var parentTableView: DynamicTableView!
    @IBOutlet weak var childTableView: DynamicTableView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    var imagePicker = UIImagePickerController()
    
    var homeViewModel: HomeViewModel!
    let disposeBag = DisposeBag()
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeViewModel = HomeViewModel()
        
        homeViewModel.parentModels
            .drive(parentTableView.rx.items(cellIdentifier: "parentCell")) { _, repository, cell in
                let parentCell = cell as? ParentCell
                parentCell?.parentName.text = repository.name
            }
            .disposed(by: disposeBag)
        
        homeViewModel.childModels
            .drive(childTableView.rx.items(cellIdentifier: "childCell")) { _, repository, cell in
                let childCell = cell as? ChildCell
                childCell?.childName.text = repository.name
            }
            .disposed(by: disposeBag)
        
        homeViewModel.image.asObservable().bind(to: homeImageView.rx.image).disposed(by: disposeBag)
    }
    
    @IBAction func selectImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            homeImageView.image = image
            
            let storageRef = storage.reference().child("\(UserDefaults.standard.string(forKey: "FAMILYCODE")!).png")
            
            let uploadData = homeImageView.image?.pngData() ?? Data()
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("ERROR")
                }
            })
            
        } else {
            print("Error")
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

class ParentCell: UITableViewCell {
    @IBOutlet weak var parentName: UILabel!
}

class ChildCell: UITableViewCell {
    @IBOutlet weak var childName: UILabel!
}
