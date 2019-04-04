//
//  ConnectModel.swift
//  EachOther
//
//  Created by daeun on 28/03/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CertifyViewModel {
    let certifyModel: CertifyModel
    
    let code: Observable<String>
    let copyCode = PublishRelay<Void>()
    
    let disposeBag = DisposeBag()
    
    init() {
        certifyModel = CertifyModel()
        self.code = certifyModel.code.asObservable()
        self.certifyModel.code.accept(generateCode())
        
        copyCode
            .subscribe(onNext: { [weak self] _ in
                UIPasteboard.general.string = self?.certifyModel.code.value
            }).disposed(by: disposeBag)
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
