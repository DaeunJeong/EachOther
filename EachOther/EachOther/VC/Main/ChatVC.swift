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
        
        chatViewModel.chatModel.bind(to: self.chatTableView.rx.items) { (tableview, row, item) in
            
            switch item {
            case .MyMessages(let value):
                let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "MyMessageCell") as! MyChatCell
                cell.myMessageLabel.text = value.message ?? ""
                return cell
            case .YourMessages(let value):
                let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "YourMessageCell") as! YourChatCell
                cell.yourNameLabel.text = value.name ?? ""
                cell.yourMessageLabel.text = value.message ?? ""
                return cell
            }
        }.disposed(by: disposeBag)
        
    }
}

class MyChatCell: UITableViewCell {
    @IBOutlet weak var myMessageLabel: UILabel!
}

class YourChatCell: UITableViewCell {
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var yourMessageLabel: UILabel!
}
