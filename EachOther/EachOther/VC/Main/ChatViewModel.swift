//
//  ChatViewModel.swift
//  EachOther
//
//  Created by daeun on 08/05/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseDatabase

class ChatViewModel {
    let clickSend = PublishRelay<Void>()
    let messageText = BehaviorRelay<String>(value: "")
    let chatModel = BehaviorRelay<[ChatModel]>(value: [])
    let disposeBag = DisposeBag()
    
    init() {
        
        let name = UserDefaults.standard.string(forKey: "NAME")
        let code = UserDefaults.standard.string(forKey: "FAMILYCODE")
        
        clickSend.subscribe { [weak self] _ in
            guard let strongSelf = self else {return}
            let message = strongSelf.messageText.value
            if let name = name, let code = code{
                Database.database().reference().child(code).child("message").childByAutoId().setValue(["name":name,"message":message,"timeStamp":ServerValue.timestamp()])
                strongSelf.messageText.accept("")
            }
        }.disposed(by: disposeBag)
        
        if let code = code {
            Database.database().reference().child(code).child("message").observe(DataEventType.value, with: { (datasnapshot) in
                var models: [ChatModel.Message] = []
                
                for item in datasnapshot.children.allObjects as! [DataSnapshot] {

                    let model = ChatModel.Message(JSON: item.value as! [String:AnyObject])
                    if let model = model {
                        models.append(model)
                    }
                }
                dump(models)
            })
        }
    }
}

class ChatData: Codable {
    let message: String
    let timeStamp: Int
    let name: String
}
