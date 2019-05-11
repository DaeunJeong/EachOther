//
//  ChatVC.swift
//  EachOther
//
//  Created by daeun on 08/05/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ChatVC: UIViewController {
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var chatViewModel: ChatViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatViewModel = ChatViewModel()
        
        sendButton.rx.tap
            .bind(to: chatViewModel.clickSend)
            .disposed(by: disposeBag)
        
        messageTextField.rx.text.orEmpty
            .bind(to: chatViewModel.messageText)
            .disposed(by: disposeBag)
        
        chatViewModel.messageText
            .bind(to: messageTextField.rx.text)
            .disposed(by: disposeBag)
        
    }
}

class MyChatCell: UITableViewCell {
    @IBOutlet weak var myMessageLabel: UILabel!
}

class YourChatCell: UITableViewCell {
    
}
