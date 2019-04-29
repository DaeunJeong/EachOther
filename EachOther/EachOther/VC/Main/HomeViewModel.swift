//
//  HomeViewModel.swift
//  EachOther
//
//  Created by daeun on 08/04/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseStorage

class HomeViewModel {
    
    var db: Firestore!
    
    let homeModel: HomeModel
    let disposeBag = DisposeBag()
    
    let familyName: Variable<String>
    let parentModels: Driver<[HomeFamilyMemberModel]>
    let childModels: Driver<[HomeFamilyMemberModel]>
    let image: Variable<UIImage>
    let clickImageButton = PublishRelay<Void>()
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(UserDefaults.standard.string(forKey: "FAMILYCODE")!).png")
        
        homeModel = HomeModel()
        familyName = homeModel.familyName
        parentModels = homeModel.parentModels.asDriver()
        childModels = homeModel.childModels.asDriver()
        image = homeModel.image
        
        let familyCode: String = UserDefaults.standard.string(forKey:"FAMILYCODE") ?? ""
        
        db.collection(familyCode).document("userInfo").collection("CHILD").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let name = document.documentID
                    //                    let date = document.data()["birthday"] as? Timestamp
                    //                    let birthday = NSDate(timeIntervalSince1970: TimeInterval(date?.seconds ?? 0 / 1000))
                    
                    let childModel = HomeFamilyMemberModel(name: name)
                    self.homeModel.childModels.value.append(childModel)
                }
            }
        }
        
        db.collection(familyCode).document("userInfo").collection("PARENT").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let name = document.documentID
                    
                    let parentModel = HomeFamilyMemberModel(name: name)
                    self.homeModel.parentModels.value.append(parentModel)
                }
            }
        }
        
        storageRef.getData(maxSize: 1 * 3000000 * 3000000, completion: { [weak self] (data, error) in
            if let error = error {
                dump(error)
            } else {
                if let data = data {
                    self?.image.value = UIImage(data: data)!
                } else {
                    print("ERROR")
                }
            }
        })
        
    }
}
