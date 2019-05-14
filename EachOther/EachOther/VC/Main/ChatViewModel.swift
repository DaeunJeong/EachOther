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
    let chatModel = BehaviorRelay<[CellType]>(value: [])
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
                var models: [CellType] = []
                
                for item in datasnapshot.children.allObjects as! [DataSnapshot] {
                    
                    let model = ChatModel.Message(JSON: item.value as! [String:AnyObject])
                    if let model = model {
                        if model.name == UserDefaults.standard.string(forKey: "NAME") {
                            models.append(.MyMessages(model))
                        } else {
                            models.append(.YourMessages(model))
                        }
                    }
                }
                self.chatModel.accept(models)
            })
        }
    }
}

enum CellType {
    case YourMessages(ChatModel.Message)
    case MyMessages(ChatModel.Message)
}
