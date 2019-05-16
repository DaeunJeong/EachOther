//
//  ConnectViewModel.swift
//  EachOther
//
//  Created by daeun on 03/04/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore


class ConnectViewModel {
    
    var db: Firestore!
    
    let connectModel: ConnectModel
    let disposeBag = DisposeBag()
    
    let code: Variable<String>
    let name: Variable<String>
    let role: Variable<String>
    let birthday: Variable<Date>
    let connectEnabled = BehaviorRelay<Bool>(value: false)
    let father = PublishRelay<Void>()
    let mother = PublishRelay<Void>()
    let child = PublishRelay<Void>()
    let connect = PublishRelay<Void>()
    let result = PublishRelay<Error?>()
    let birthDayString = BehaviorRelay<String>(value: "")
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        connectModel = ConnectModel()
        
        self.code = connectModel.code
        self.name = connectModel.name
        self.role = connectModel.role
        self.birthday = connectModel.birthday
        
        func checkValid(_ text: String) -> Bool {
            return text.count > 0
        }
        
        Observable.combineLatest(self.connectModel.code.asObservable().map(checkValid),
                                 self.connectModel.name.asObservable().map(checkValid),
                                 resultSelector: { s1, s2 in s1 && s2})
            .subscribe(onNext:{ [weak self] isConnectEnabled in
                self?.connectEnabled.accept(isConnectEnabled)
            }).disposed(by: disposeBag)
        
        connectModel.birthday.asObservable().subscribe {[weak self] date in
            guard let strongSelf = self else {return}
            if let date = date.element {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy MM dd"
                strongSelf.birthDayString.accept(formatter.string(from: date))
            }
        }.disposed(by: disposeBag)
        
        connect
            .subscribe(onNext: { [weak self] _ in
                self?.db.collection(self?.connectModel.code.value ?? "ERROR").document("userInfo").collection(self?.connectModel.role.value ?? "").document(self?.connectModel.name.value ?? "ERROR").setData([
                    "birthday": self?.birthDayString.value ?? "ERROR"
                ]) { err in
                    if let err = err {
                        self?.result.accept(err)
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "2019 MM dd"
                        let thisYearBirthday = formatter.string(from: self?.connectModel.birthday.value ?? Date())
                        self?.db.collection(self?.connectModel.code.value ?? "ERROR").document("schedule").collection("schedule").document(thisYearBirthday).setData(["comment":"\(self?.connectModel.name.value ?? "") 생일"]) { err in
                            if let err = err {
                                dump(err)
                            }
                        }
                        
                        UserDefaults.standard.set(self?.connectModel.name.value, forKey: "NAME")
                        UserDefaults.standard.set(self?.connectModel.code.value, forKey: "FAMILYCODE")
                        UserDefaults.standard.set(self?.birthDayString.value, forKey: "BIRTHDAY")
                        self?.result.accept(err)
                    }
                }
            }).disposed(by: disposeBag)
        
        father
            .subscribe(onNext: { [weak self] _ in
                self?.connectModel.role.value = "PARENT"
            }).disposed(by: disposeBag)
        
        mother
            .subscribe(onNext: { [weak self] _ in
                self?.connectModel.role.value = "PARENT"
            }).disposed(by: disposeBag)
        
        child
            .subscribe(onNext: { [weak self] _ in
                self?.connectModel.role.value = "CHILD"
            }).disposed(by: disposeBag)
        

    }

}
