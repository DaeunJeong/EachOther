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


class ConnectViewModel {
    let connectModel: ConnectModel
    let disposeBag = DisposeBag()
    
    let code: Variable<String>
    let role: Variable<String>
    let birthday: Variable<Date>
    let father = PublishRelay<Void>()
    let mother = PublishRelay<Void>()
    let child = PublishRelay<Void>()
    let connect = PublishRelay<Void>()


    init() {
        connectModel = ConnectModel()
        
        self.code = connectModel.code
        self.role = connectModel.role
        self.birthday = connectModel.birthday
        
        connect
            .subscribe(onNext: { [weak self] _ in
                //todo
            }).disposed(by: disposeBag)
        
        father
            .subscribe(onNext: { [weak self] _ in
                self?.connectModel.role.value = "FATHER"
            }).disposed(by: disposeBag)
        
        mother
            .subscribe(onNext: { [weak self] _ in
                self?.connectModel.role.value = "MOTHER"
            }).disposed(by: disposeBag)
        
        child
            .subscribe(onNext: { [weak self] _ in
                self?.connectModel.role.value = "CHILD"
            }).disposed(by: disposeBag)
    }
}
