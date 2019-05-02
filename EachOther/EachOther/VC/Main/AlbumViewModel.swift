//
//  AlbumViewModel.swift
//  EachOther
//
//  Created by daeun on 29/04/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseFirestore
import FirebaseStorage

class AlbumViewModel {
    
    var db: Firestore!
    let albumModels = Variable<[AlbumModel]>([])
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        let storage = Storage.storage()
        
        let familyCode: String = UserDefaults.standard.string(forKey:"FAMILYCODE") ?? ""
        
        db.collection(familyCode).document("album").collection("album").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let imagePath = document.data()["imagePath"] as? String
                    let title = document.data()["title"] as? String
                    let date = document.data()["date"] as? String
                    let place = document.data()["place"] as? String
                    
                    if let imagePath = imagePath, let title = title, let date = date, let place = place {
                        
                        let storageRef = storage.reference().child(imagePath)
                        print(imagePath)
                        storageRef.getData(maxSize: 1 * 3000000 * 3000000, completion: { (data, error) in
                            if let error = error  {
                                dump(error)
                            } else {
                                if let data = data {
                                    let albumModel = AlbumModel()
                                    albumModel.data.value = data
                                    albumModel.date.value = date
                                    albumModel.title.value = title
                                    albumModel.place.value = place
                                    self.albumModels.value.append(albumModel)
                                } else {
                                    print("ERROR")
                                }
                            }
                        })
                    }
                    else {
                        print("NONE")
                    }
                }
            }
        }
    }
}
