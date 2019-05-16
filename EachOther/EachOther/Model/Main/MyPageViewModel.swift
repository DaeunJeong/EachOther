//
//  MyPageViewModel.swift
//  EachOther
//
//  Created by daeun on 16/05/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseFirestore

class MyPageViewModel {
    var db: Firestore!
    let disposeBag = DisposeBag()
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    struct Input {
        let inputName: Driver<String>
        let inputBirthday: Driver<Date>
        let clickComplete: Signal<Void>
        let clickLogout: Signal<Void>
    }
    
    struct Output {
        let name: Driver<String>
        let birthday: Driver<Date>
        let doLogout: PublishRelay<Bool>
        let result: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let inputName = BehaviorRelay<String>(value: "")
        let inputBirthday = BehaviorRelay<Date>(value: Date())
        let doLogout = PublishRelay<Bool>()
        let name = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: "NAME") ?? "")
        let birthday = BehaviorRelay<Date>(value: Date())
        let result = PublishRelay<Bool>()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        birthday.accept(formatter.date(from: UserDefaults.standard.string(forKey: "BIRTHDAY") ?? "") ?? Date())
        
        input.inputName.asObservable().subscribe { name in
            if let name = name.element {
               inputName.accept(name)
            }
        }.disposed(by: disposeBag)
        
        input.inputBirthday.asObservable().subscribe { date in
            if let date = date.element {
                inputBirthday.accept(date)
            }
        }.disposed(by: disposeBag)
        
        input.clickComplete.asObservable().subscribe { [weak self] _ in
            guard let strongSelf = self else {return}
            let familyCode = UserDefaults.standard.string(forKey: "FAMILYCODE") ?? ""
            let name = UserDefaults.standard.string(forKey: "NAME") ?? ""
            let role = UserDefaults.standard.string(forKey: "ROLE") ?? ""
            strongSelf.db.collection(familyCode).document("userInfo").collection(role).document(name).delete() { err in
                if let err = err {
                    dump(err)
                    result.accept(false)
                } else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy MM dd"
                    let birthdayString = formatter.string(from: inputBirthday.value)
                    strongSelf.db.collection(familyCode).document("userInfo").collection(role).document(inputName.value).setData(["birthday":birthdayString]) { err in
                        if let err = err {
                            dump(err)
                            result.accept(false)
                        } else {
                            UserDefaults.standard.set(inputName.value, forKey: "NAME")
                            UserDefaults.standard.set(birthdayString, forKey: "BIRTHDAY")
                            result.accept(true)
                        }
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        input.clickLogout.asObservable().subscribe { _ in
            doLogout.accept(true)
        }.disposed(by: disposeBag)
        
        return Output(name: name.asDriver(), birthday: birthday.asDriver(), doLogout: doLogout, result: result)
    }
}
