//
//  AddAlbumViewModel.swift
//  EachOther
//
//  Created by daeun on 30/04/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseFirestore
import FirebaseStorage

class AddAlbumViewModel {
    var db: Firestore!
    let disposeBag = DisposeBag()
    let selectDate = PublishRelay<Date>()
    let date = BehaviorRelay<String>(value: "")
    let title = BehaviorRelay<String>(value: "")
    let place = BehaviorRelay<String>(value: "")
    let image = BehaviorRelay<Data>(value: Data())
    let clickComplete = PublishRelay<Void>()
    let result = PublishRelay<Bool>()
    
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        let storage = Storage.storage()
        
        selectDate.subscribe(onNext:{ [weak self] date in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            let dateString = dateFormatter.string(from: date)
            
            self?.date.accept(dateString)
        }).disposed(by: disposeBag)
        
        let familyCode: String = UserDefaults.standard.string(forKey:"FAMILYCODE") ?? ""
        let albumCode = generateCode()
        let imagePath = "\(familyCode)/\(albumCode).png"
        
        clickComplete.subscribe{ [weak self]_ in
            self?.db.collection(familyCode).document("album").collection("album").document(albumCode).setData(["date": self?.date.value,"title":self?.title.value,"place":self?.place.value,"imagePath":imagePath]) { err in
                if let err = err {
                    dump(err)
                    self?.result.accept(false)
                } else {
                    self?.result.accept(true)
                }
            }
            let storageRef = storage.reference().child(imagePath)
            
            let uploadData = self?.image.value ?? Data()
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("ERROR")
                }
            })
            }.disposed(by: disposeBag)
    }
    
    func generateCode() -> String {
        let randomChars = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
                           "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
                           "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        var code = ""
        for _ in 0 ..< 10 {
            code.append(randomChars.randomElement()!)
        }
        return code
    }
}
