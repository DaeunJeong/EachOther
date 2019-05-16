//
//  AddScheduleModel.swift
//  EachOther
//
//  Created by daeun on 15/05/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseFirestore

class AddScheduleViewModel {
    var db: Firestore!
    let disposeBag = DisposeBag()
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    struct Input {
        let clickComplete: Signal<Void>
        let comment: Driver<String>
        let date: Driver<Date>
    }
    
    struct Output {
        let result: Driver<AddScheduleResult>
    }

    func transform(input: Input) -> Output {
        
        let familyCode: String = UserDefaults.standard.string(forKey:"FAMILYCODE") ?? ""
        let result = PublishRelay<AddScheduleResult>()
        let dateString = BehaviorRelay<String>(value: "")
        let comment = BehaviorRelay<String>(value: "")
        
        input.date.asObservable().subscribe { date in
            if let date = date.element {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy MM dd"
                dateString.accept(formatter.string(from: date))
            } else {
                dateString.accept("")
            }
        }.disposed(by: disposeBag)
        
        input.comment.asObservable().subscribe { inputComment in
            if let inputComment = inputComment.element {
                comment.accept(inputComment)
            }
            
        }.disposed(by: disposeBag)
        
        input.clickComplete.asObservable().subscribe { [weak self] _ in
            guard let strongSelf = self else {return}

            strongSelf.db.collection(familyCode).document("schedule").collection("schedule").document(dateString.value).setData(["comment": comment.value]) { err in
                if let err = err {
                    dump(err)
                    result.accept(.fail)
                } else {
                    result.accept(.success)
                }
            }
        }.disposed(by: disposeBag)
        
        return Output(result: result.asDriver(onErrorJustReturn: .none))
        
    }
}

enum AddScheduleResult {
    case none,success,fail
}
