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

class AlbumViewModel {
    
    var db: Firestore!
    let albumModels = Variable<[AlbumModel]>?(nil)
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
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
                        let albumModel = AlbumModel(imagePath: imagePath, date: date, title: title, place: place)
                        self.albumModels?.value.append(albumModel)
                    }
                    else {
                        print("NONE")
                    }
                }
            }
        }
    }
}
