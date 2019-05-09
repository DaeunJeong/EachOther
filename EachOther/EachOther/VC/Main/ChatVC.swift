//
//  ChatVC.swift
//  EachOther
//
//  Created by daeun on 08/05/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

class MyChatCell: UITableViewCell {
    @IBOutlet weak var myMessageLabel: UILabel!
}

class YourChatCell: UITableViewCell {
    
}
