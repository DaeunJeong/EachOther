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

class ChatViewModel {
    let clickSend = PublishRelay<Void>()
    let messageText = BehaviorRelay<String>(value: "")
    
}
